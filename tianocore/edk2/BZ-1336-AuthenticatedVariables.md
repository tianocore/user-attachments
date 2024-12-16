# UEFI Authenticated Variables (EFI_VARIABLE_AUTHENTICATION_2)

The intent behind this investigation was to have a better understanding of how UEFI authenticated variables certificate chaining works.

## Preamble

This section may be considered superfluous but acts as background information for the underlying data structures.
Feel free to skip this section if you already understand how authenticated variables are structured.

### Layout

The layout of `EFI_VARIABLE_AUTHENTICATION_2` authenticated variables is the following:

```txt
[EFI_TIME][WIN_CERTIFICATE][SIGNATURE][DATA]
    |            |             |        |
    |            |             |         `---- Variable Size
    |            |              `------------- Variable Size
    |             `--------------------------- Fixed Size
     `---------------------------------------- Fixed Size

Where SIGNATURE = Asn.1 `SignedData` object
```

#### EFI_TIME

```c
 ///
 /// EFI Time Abstraction:
 ///  Year:       1900 - 9999
 ///  Month:      1 - 12
 ///  Day:        1 - 31
 ///  Hour:       0 - 23
 ///  Minute:     0 - 59
 ///  Second:     0 - 59
 ///  Nanosecond: 0 - 999,999,999
 ///  TimeZone:   -1440 to 1440 or 2047
 ///
 typedef struct {
   UINT16  Year;
   UINT8   Month;
   UINT8   Day;
   UINT8   Hour;
   UINT8   Minute;
   UINT8   Second;
   UINT8   Pad1;
   UINT32  Nanosecond;
   INT16   TimeZone;
   UINT8   Daylight;
   UINT8   Pad2;
 } EFI_TIME;
```

`EFI_TIME` is straightforward to understand, as the specification lays out, the `Year, Month, Day, Hour, Min, Second`
may be set to any time. However `Pad1, Nanosecond, TimeZone, Daylight, Pad2` are unused and should be set to `0`.
This field is later hashed in the signature digest. Together these two help prevent replay attacks since the variable
must always have a time in the future in order to update it.

[For more information see here.](https://dox.ipxe.org/structEFI__TIME.html#:~:text=Detailed%20Description%20EFI%20Time%20Abstraction%3A%20Year%3A%201900%20-,2047.%20Definition%20at%20line%2074%20of%20file%20UefiBaseType.h.)

#### WIN_CERTIFICATE

```c
typedef struct _WIN_CERTIFICATE {
  DWORD dwLength;
  WORD  wRevision;
  WORD  wCertificateType;
  BYTE  bCertificate[ANYSIZE_ARRAY];
} WIN_CERTIFICATE, *LPWIN_CERTIFICATE;
```

[For more information see here.](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/ns-wintrust-win_certificate)

#### PKCS#7 `SignedData`
>
> Note this is not a complete breakdown of PKCS#7 only the information relevant for UEFI.

For authenticiated variables (EFI_VARIABLE_AUTHENTICATION_2) the signature is really the `SignedData` structure from a
[PKCS#7 signature](https://www.itu.int/ITU-T/formal-language/itu-t/x/x420/1999/PKCS7.html). Typically a `SignedData`
structure is enclosed in a ContentInfo structure indicating the content is a `PKCS#7 Signature`, but for UEFI code in
TianoCore and its derivatives (project MU) the ContentInfo structure is expected to have been discarded.

> ~ *Technically I believe the spec calls for UEFI to support both the SignData structure and ContentInfo Structure* ~

> ~ As of 1/22/23 it appears that someone fixed this in Tianocore... ~

Later in [UEFI Specification](#uefi-Specification), this document will go deeper into how the structure should be filled
out but for now here's reference ASN.1 Syntax for a `SignedData`. Note that the signatures (and a reference to who signed them)
go into the `SignerInfo` section and certificates (X.509) go in the `Certificates` section.

```asn1
SignedData ::= SEQUENCE {
  version           Version,
  digestAlgorithms  DigestAlgorithmIdentifiers,
  contentInfo       ContentInfo,
  certificates      [0]  CertificateSet OPTIONAL,
  crls              [1]  CertificateRevocationLists OPTIONAL,
  signerInfos       SignerInfos
}

CertificateSet ::= SET OF CertificateChoice

CertificateChoice ::= CHOICE {
  certificate           Certificate,
  extendedCertificate   [0]  ExtendedCertificate, -- Obsolete
  attributeCertificate  [1]  AttributeCertificate
}

SignerInfos ::= SET OF SignerInfo

SignerInfo ::= SEQUENCE {
  version                    Version,
  signerIdentifier           SignerIdentifier,
  digestAlgorithm            DigestAlgorithmIdentifier,
  authenticatedAttributes    [0]  Attributes OPTIONAL,
  digestEncryptionAlgorithm  DigestEncryptionAlgorithmIdentifier,
  encryptedDigest            EncryptedDigest,
  unauthenticatedAttributes  [1]  Attributes OPTIONAL
}

SignerIdentifier ::= CHOICE {
  issuerAndSerialNumber  IssuerAndSerialNumber,
  subjectKeyIdentifier   [2]  SubjectKeyIdentifier
}

IssuerAndSerialNumber ::= SEQUENCE {
  issuer        Name,
  serialNumber  CertificateSerialNumber
}
```

## UEFI Specification

The UEFI Specification in section 8.2.6 `"Using the EFI_VARIABLE_AUTHENTICATION_2 descriptor"` describes
how to build an authenticated variable (v2). In particular there are two sections that are the most relevant.

The first describes *how* the asn.1 SignedData structure should be constructed.

> 4. Construct a DER-encoded `SignedData` structure per PKCS#7 version 1.5 (RFC 2315), which shall be supported
>    both with and without a DER-encoded ContentInfo structure per PKCS#7 version 1.5, with the signed content
>    as follows:
>
>           a - SignedData.version shall be set to 1
>           b - SignedData.digestAlgorithms shall contain the digest algorithm used when preparing the signature.
>                Digest algorithms of SHA-256, SHA-384, SHA-512 are accepted.
>           c - SignedData.contentInfo.contentType shall be set to id-data
>           d - SignedData.contentInfo.content shall be absent
>                (the content is provided in the Data parameter to the SetVariable() call)
>           e - SignedData.certificates shall contain, at a minimum, the signer’s DER-encoded X.509 certificate.
>           f - SignedData.crls is optional.
>           g - SignedData.signerInfos shall be constructed as:
>                   — SignerInfo.version shall be set to 1
>                   — SignerInfo.issuerAndSerial shall be present and as in the signer’s certificate 
>                   — SignerInfo.authenticatedAttributes shall not be present.
>                   — SignerInfo.digestEncryptionAlgorithm shall be set to the algorithm used to sign the data.
>                   — SiginerInfo.encryptedDigest shall be present
>                   — SignerInfo.unauthenticatedAttributes shall not be present.

> ~ *So pretty sure that Tianocore Edk2 (and project MU) doesn't support the following sections: ~
>  * Digest algorithms of SHA-256, SHA-384, SHA-512 are accepted.
>       * https://github.com/tianocore/edk2/blob/37d3eb026a766b2405daae47e02094c2ec248646/SecurityPkg/Library/AuthVariableLib/AuthService.c#L1970


The second describes *how* the firmware should be implemented and what behavior SetVariable(...) should express.


Pay special attention to the 3rd bulletin.

> 5. If the variable is the global PK variable or the global KEK variable, verify that the signature has been made
>  with the current Platform Key.
>
>            • If the variable is the “db”, “dbt”, “dbr”, or “dbx” variable mentioned in step 3, verify that
>              the signer’s certificate chains to a certificate in the Key Exchange Key database (or that the
>              signature was made with the current Platform Key).
>
>            • If the variable is the “OsRecoveryOrder” or “OsRecovery####” variable mentioned in step 3,
>              verify that the signer’s certificate chains to a certificate in the “dbr” database or the
>              Key Exchange Key database, or that the signature was made with the current Platform Key.
>
>            • Otherwise, if the variable is none of the above, it shall be designated a Private Authenticated 
>              Variable. If the Private Authenticated Variable does not exist, then the CN of the signing
>              certificate’s Subject and the hash of the tbsCertificate of the top-level issuer certificate
>              (or the signing certificate itself if no other certificates are present or the certificate chain
>              is of length 1) in SignedData.certificates is registered for use in subsequent verifications of
>              this variable. Implementations may store just a single hash of these two elements to reduce storage
>              requirements. If the Private Authenticated variable previously existed, that the signer’s
>              certificate chains to the information previously associated with the variable. Observe that because
>              no revocation list exists for them, if any member of the certificate chain is compromised, the only
>              method to revoke trust in a certificate for a Private Authenticated Variable is to delete the
>              variable, re-issue all certificate authorities in the chain, and re-create the variable using the
>              new certificate chain. As such, the remaining benefits may be strong identification of the originator,
>              or compliance with some certificate authority policy. Further note that the PKCS7 bundle for the
>              authenticated variable update must contain the signing certificate chain, through and including the
>              full certificate of the desired trust anchor. The trust anchor might be a mid-level certificate or
>              root, though many roots may be unsuitable trust anchors due to the number of CAs they issue 
>              different purposes. Some tools require non-default parameters to include the trust anchor certificate.

From the two peices of information, we know how the SignedData structure should be constructed and see that the
`Common Name (CN) of the signing certificate’s Subject and the hash of the tbsCertificate of the top-level issuer
certificate (or the signing certificate itself if no other certificates are present or the certificate chain is of
length 1` is used to validate the payload.

> ~ One question I have here is the last sentence of the third bulletin `"Some tools require non-default parameters to
> include the trust anchor certificate"`. I'm not sure what this actually means and spent awhile trying to find a
> tool that would work. ~

----

## UEFI Code

> **File**: Common\MU_TIANO\SecurityPkg\Library\AuthVariableLib\AuthService.c
>
> **Function**: VerifyTimeBasedPayload
>
> ```c
>   /* .... irrelevant code .... */
> 
>   if (AuthVarType == AuthVarTypePk) {
>     /* Handle PK */
>   } else if (AuthVarType == AuthVarTypeKek) {
>    /* Handle KEK */
>   } else if (AuthVarType == AuthVarTypePriv) {
>    //
>    // Process common authenticated variable except PK/KEK/DB/DBX/DBT.
>    // Get signer's certificates from SignedData.
>    //
>    VerifyStatus = Pkcs7GetSigners (
>                     SigData,
>                     SigDataSize,
>                     &SignerCerts,
>                     &CertStackSize,
>                     &TopLevelCert,
>                     &TopLevelCertSize
>                     );
>    if (!VerifyStatus) {
>      goto Exit;
>    }
>
>    //
>    // Get previously stored signer's certificates from certdb or certdbv for existing
>    // variable. Check whether they are identical with signer's certificates
>    // in SignedData. If not, return error immediately.
>    //
>    if (OrgTimeStamp != NULL) {
>      VerifyStatus = FALSE;
>
>      Status = GetCertsFromDb (VariableName, VendorGuid, Attributes, &CertsInCertDb, &CertsSizeinDb);
>
>      if (EFI_ERROR (Status)) {
>        goto Exit;
>      }
>
>      if (CertsSizeinDb == SHA256_DIGEST_SIZE) {
>        //
>        // Check hash of signer cert CommonName + Top-level issuer tbsCertificate against data in CertDb
>        //
>        CertDataPtr = (EFI_CERT_DATA *)(SignerCerts + 1);
>        Status      = CalculatePrivAuthVarSignChainSHA256Digest (
>                        CertDataPtr->CertDataBuffer,
>                        ReadUnaligned32 ((UINT32 *)&(CertDataPtr->CertDataLength)),
>                        TopLevelCert,
>                        TopLevelCertSize,
>                        Sha256Digest
>                        );
>        
>        if (EFI_ERROR (Status) || (CompareMem (Sha256Digest, CertsInCertDb, CertsSizeinDb) != 0)) {
>
>          goto Exit;
>        }
>      } else {
>        //
>        // Keep backward compatible with previous solution which saves whole signer certs stack in CertDb
>        //
>        if ((CertStackSize != CertsSizeinDb) ||
>            (CompareMem (SignerCerts, CertsInCertDb, CertsSizeinDb) != 0))
>        {
>          goto Exit;
>        }
>      }
>    }
>
>    VerifyStatus = Pkcs7Verify (
>                     SigData,
>                     SigDataSize,
>                     TopLevelCert,
>                     TopLevelCertSize,
>                     NewData,
>                     NewDataSize
>                     );
>    if (!VerifyStatus) {
>      goto Exit;
>    }
>
>    if ((OrgTimeStamp == NULL) && (PayloadSize != 0)) {
>      //
>      // When adding a new common authenticated variable, always save Hash of cn of signer cert + tbsCertificate of Top-level issuer
>      //
>      CertDataPtr = (EFI_CERT_DATA *)(SignerCerts + 1);
>      Status      = InsertCertsToDb (
>                      VariableName,
>                      VendorGuid,
>                      Attributes,
>                      CertDataPtr->CertDataBuffer,
>                      ReadUnaligned32 ((UINT32 *)&(CertDataPtr->CertDataLength)),
>                      TopLevelCert,
>                      TopLevelCertSize
>                      );
>      if (EFI_ERROR (Status)) {
>        VerifyStatus = FALSE;
>        goto Exit;
>      }
>    }
>```


The first thing the UEFI code does is immediately retrieve the *SignerCerts* and *TopLevelCert* via `Pkcs7GetSigners`

> **File**: MU_BASECORE\CryptoPkg\Library\BaseCryptLib\Pk\CryptPkcs7VerifyCommon.c
>
> **Function**: Pkcs7GetSigners
>
> ```c
>/**
>  Get the signer's certificates from PKCS#7 signed data as described in "PKCS #7:
>  Cryptographic Message Syntax Standard". The input signed data could be wrapped
>  in a ContentInfo structure.
>
>  If P7Data, CertStack, StackLength, TrustedCert or CertLength is NULL, then
>  return FALSE. If P7Length overflow, then return FALSE.
>
>  Caution: This function may receive untrusted input.
>  UEFI Authenticated Variable is external input, so this function will do basic
>
>  check for PKCS#7 data structure.
>
>  @param[in]  P7Data       Pointer to the PKCS#7 message to verify.
>  @param[in]  P7Length     Length of the PKCS#7 message in bytes.
>  @param[out] CertStack    Pointer to Signer's certificates retrieved from P7Data.
>                           It's caller's responsibility to free the buffer with
>                           Pkcs7FreeSigners().
>                           This data structure is EFI_CERT_STACK type.
>  @param[out] StackLength  Length of signer's certificates in bytes.
>  @param[out] TrustedCert  Pointer to a trusted certificate from Signer's certificates.
>                           It's caller's responsibility to free the buffer with
>                           Pkcs7FreeSigners().
>  @param[out] CertLength   Length of the trusted certificate in bytes.
>
>  @retval  TRUE            The operation is finished successfully.
>  @retval  FALSE           Error occurs during the operation.
>
>**/
>BOOLEAN
>EFIAPI
>Pkcs7GetSigners (
>  IN  CONST UINT8  *P7Data,
>  IN  UINTN        P7Length,
>  OUT UINT8        **CertStack,
>  OUT UINTN        *StackLength,
>  OUT UINT8        **TrustedCert,
>  OUT UINTN        *CertLength
>  )
>{
>  PKCS7        *Pkcs7;
>  BOOLEAN      Status;
>  UINT8        *SignedData;
>  CONST UINT8  *Temp;
>  UINTN        SignedDataSize;
>  BOOLEAN      Wrapped;
>
>  STACK_OF (X509)   *Stack;
>  UINT8  Index;
>  UINT8  *CertBuf;
>  UINT8  *OldBuf;
>  UINTN  BufferSize;
>  UINTN  OldSize;
>  UINT8  *SingleCert;
>  UINTN  SingleCertSize;
>
>  if ((P7Data == NULL) || (CertStack == NULL) || (StackLength == NULL) ||
>      (TrustedCert == NULL) || (CertLength == NULL) || (P7Length > INT_MAX))
>  {
>    return FALSE;
>  }
>
>  Status = WrapPkcs7Data (P7Data, P7Length, &Wrapped, &SignedData, &SignedDataSize);
>  if (!Status) {
>    return Status;
>  }
>
>  Status     = FALSE;
>  Pkcs7      = NULL;
>  Stack      = NULL;
>  CertBuf    = NULL;
>  OldBuf     = NULL;
>  SingleCert = NULL;
>
>  //
>  // Retrieve PKCS#7 Data (DER encoding)
>  //
>  if (SignedDataSize > INT_MAX) {
>    goto _Exit;
>  }
>
>  Temp  = SignedData;
>  Pkcs7 = d2i_PKCS7 (NULL, (const unsigned char **)&Temp, (int)SignedDataSize);
>  if (Pkcs7 == NULL) {
>    goto _Exit;
>  }
>
>  //
>  // Check if it's PKCS#7 Signed Data (for Authenticode Scenario)
>  //
>  if (!PKCS7_type_is_signed (Pkcs7)) {
>    goto _Exit;
>  }
>
>  Stack = PKCS7_get0_signers (Pkcs7, NULL, PKCS7_BINARY);
>  if (Stack == NULL) {
>    goto _Exit;
>  }
>
>  //
>  // Convert CertStack to buffer in following format:
>  // UINT8  CertNumber;
>  // UINT32 Cert1Length;
>  // UINT8  Cert1[];
>  // UINT32 Cert2Length;
>  // UINT8  Cert2[];
>  // ...
>  // UINT32 CertnLength;
>  // UINT8  Certn[];
>  //
>  BufferSize = sizeof (UINT8);
>  OldSize    = BufferSize;
>
>  for (Index = 0; ; Index++) {
>    Status = X509PopCertificate (Stack, &SingleCert, &SingleCertSize);
>    if (!Status) {
>      break;
>    }
>
>    OldSize    = BufferSize;
>    OldBuf     = CertBuf;
>    BufferSize = OldSize + SingleCertSize + sizeof (UINT32);
>    CertBuf    = malloc (BufferSize);
>
>    if (CertBuf == NULL) {
>      goto _Exit;
>    }
>
>    if (OldBuf != NULL) {
>      CopyMem (CertBuf, OldBuf, OldSize);
>      free (OldBuf);
>      OldBuf = NULL;
>    }
>
>    WriteUnaligned32 ((UINT32 *)(CertBuf + OldSize), (UINT32)SingleCertSize);
>    CopyMem (CertBuf + OldSize + sizeof (UINT32), SingleCert, SingleCertSize);
>
>    free (SingleCert);
>    SingleCert = NULL;
>  }
>
>  if (CertBuf != NULL) {
>    //
>    // Update CertNumber.
>    //
>    CertBuf[0] = Index;
>
>    *CertLength  = BufferSize - OldSize - sizeof (UINT32);
>    *TrustedCert = malloc (*CertLength);
>    if (*TrustedCert == NULL) {
>      goto _Exit;
>    }
>
>    CopyMem (*TrustedCert, CertBuf + OldSize + sizeof (UINT32), *CertLength);
>    *CertStack   = CertBuf;
>    *StackLength = BufferSize;
>    Status       = TRUE;
>  }
>
>_Exit:
>  //
>  // Release Resources
>  //
>  if (!Wrapped) {
>    free (SignedData);
>  }
>
>  if (Pkcs7 != NULL) {
>    PKCS7_free (Pkcs7);
>  }
>
>  if (Stack != NULL) {
>    sk_X509_pop_free (Stack, X509_free);
>  }
>
>  if (SingleCert !=  NULL) {
>    free (SingleCert);
>  }
>
>  if (!Status && (CertBuf != NULL)) {
>    free (CertBuf);
>    *CertStack = NULL;
>  }
>
>  if (OldBuf != NULL) {
>    free (OldBuf);
>  }
>
>  return Status;
>}
>```

### Description

```
┌──────────────────────────────┐
│  Root Certificate            │
└─────────┬────────────────────┘
          │ Issues
          │
┌─────────▼────────────────────┐
│  Intermediate Certificate 0  │
└─────────┬────────────────────┘
          │  Issues
          ▼
        .....  N Certifcates in Chain

          │  Issues
┌─────────▼────────────────────┐Top Level Cert
│  Intermediate Certificate N  ├─────┐
└─────────┬────────────────────┘     │
          │ Issues                   │
┌─────────▼──────────────────────┐   │
│  Intermediate Certificate N+1  │   │
└─────────┬──────────────────────┘   │
          │                          │
          │ Issues                   │
          │                          │
┌─────────▼───────────┐              │
│  Leaf Certificate   │              │
└─────────┬───────────┘              │ Signs
          │                          │
          │  Sign                    │
          │                          │
    ┌─────▼──────┐                   │
    │   Digest   ◄───────────────────┘  PKCS#7
    └────────────┘
```

The code as exists today in TianoCore, and project MU creates the above relationship where every cert up until the Top Level Cert (Trust anchor) must exist in the asn.1 Certificate stack.

`pkcs7_get0_signers()` returns the asn.1 `SignedData.SignerInfos` X.509 certificate stack. Meaning the `TrustedCert` or `TopLevelCert` (as in VerifyTimeBasedPayload) or as it's used (Trust Anchor) used must also be a signer of the digest.

This feels incorrect as the intermediate certificate shouldn't be used for signing the digest.

## Resources

1. [SignTool](https://learn.microsoft.com/en-us/dotnet/framework/tools/signtool-exe)
2. [Latest UEFI Specification (2.10)](https://uefi.org/sites/default/files/resources/UEFI_Spec_2_10_Aug29.pdf)
   1. 8.2.6 Using the EFI_VARIABLE_AUTHENTICATION_2 descriptor
3. [PKCS#7 Signed Data](https://www.itu.int/ITU-T/formal-language/itu-t/x/x420/1999/PKCS7.html)
4. [Trusted Cert and Certificate Chain](https://www.openssl.org/docs/man3.0/man1/openssl-verification-options.html#:~:text=From%20the%20OpenSSL%20perspective%2C%20a%20trust%20anchor%20is,this%20is%20indicated%20by%20the%20TRUSTED%20CERTIFICATE%20string.)


<https://edk2.groups.io/g/devel/message/16000>
