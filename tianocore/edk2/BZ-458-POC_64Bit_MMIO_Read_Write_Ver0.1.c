/**
  Reads a 64-bit MMIO register.

  Reads the 64-bit MMIO register specified by Address. The 64-bit read value is
  returned. This function must guarantee that all MMIO read and write
  operations are serialized.

  If 64-bit MMIO register operations are not supported, then ASSERT().
  If Address is not aligned on a 64-bit boundary, then ASSERT().

  @param  Address The MMIO register to read.

  @return The value read.

**/
UINT64
EFIAPI
InternalMmioRead64 (
  IN      UINTN                     Address
  )
{
  UINT64                            Value;

  ASSERT ((Address & 7) == 0);

  __asm {
    push esi

  ;;push xmm0
    lea esp, [esp-16]    ;Reserve space on the stack
    vmovdqu [esp], xmm0  ;Save xmm0 - unaligned write

    movd esi, Address
    movq xmm0, QWORD PTR ds:[esi]
    movq Value, xmm0

  ;;pop xmm0
    vmovdqu xmm0, [esp]  ;Restore xmm0 - unaligned write
    lea esp, [esp+16]    ;Update the stack

    pop esi
  }

  return Value;
}

/**
  Writes a 64-bit MMIO register.

  Writes the 64-bit MMIO register specified by Address with the value specified
  by Value and returns Value. This function must guarantee that all MMIO read
  and write operations are serialized.

  If 64-bit MMIO register operations are not supported, then ASSERT().
  If Address is not aligned on a 64-bit boundary, then ASSERT().

  @param  Address The MMIO register to write.
  @param  Value   The value to write to the MMIO register.

**/
UINT64
EFIAPI
InternalMmioWrite64 (
  IN      UINTN                     Address,
  IN      UINT64                    Value
  )
{
  ASSERT ((Address & 7) == 0);

  __asm {
    push esi

  ;;push xmm0
    lea esp, [esp-16]    ;Reserve space on the stack
    vmovdqu [esp], xmm0  ;Save xmm0 - unaligned write

    movd esi, Address
    movq xmm0, Value
    movq QWORD PTR ds:[esi], xmm0

  ;;pop xmm0
    vmovdqu xmm0, [esp]  ;Restore xmm0 - unaligned write
    lea esp, [esp+16]    ;Update the stack

    pop esi
  }

  return Value;
}

/**
  MmioRead64 wrapper to print assembly code for emulation

  @param Address  - The MMIO register to Read.

  @return Value.
**/
UINT64
EFIAPI
UbiosInternalMmioRead64 (
  IN UINTN    Address
  )
{
  if (UbiosGenerationEnabled ()) {
    DEBUG ((EFI_D_ERROR, "\n  lea esp, [esp-24]\n"));
    DEBUG ((EFI_D_ERROR, "\n  vmovdqu [esp], xmm0\n"));                          //Save the xmm0 on stack

    DEBUG ((EFI_D_ERROR, "\n  movq xmm0, QWORD PTR ds:[0%08xh]\n", Address));    //64bit MMIO read
    DEBUG ((EFI_D_ERROR, "\n  movq QWORD PTR [esp+16], xmm0\n"));                //Store the 64bit register value on stack
    DEBUG ((EFI_D_ERROR, "\n  mov eax, DWORD PTR [esp+16]\n"));                  //eax = Low 32bit of the value read from the register
    DEBUG ((EFI_D_ERROR, "\n  mov edx, DWORD PTR [esp+20]\n"));                  //edx = High 32bit of the value read from the register

    DEBUG ((EFI_D_ERROR, "\n  vmovdqu xmm0, [esp]\n"));                          //Restore the xmm0
    DEBUG ((EFI_D_ERROR, "\n  lea esp, [esp+24]\n"));                            //Update the stack
  }

  return InternalMmioRead64 (Address);
}

/**
  MmioWrite64 wrapper to print assembly code for emulation

  @param Address  - The MMIO register to write.
  @param Value    - The data write to the register

  @return Value.
**/
UINT64
EFIAPI
UbiosInternalMmioWrite64 (
  IN UINTN    Address,
  IN UINT64   Value
  )
{
  if (UbiosGenerationEnabled ()) {
    DEBUG ((EFI_D_ERROR, "\n  lea esp, [esp-24]\n"));
    DEBUG ((EFI_D_ERROR, "\n  vmovdqu [esp], xmm0\n"));                                            //Save the xmm0 on stack

    DEBUG ((EFI_D_ERROR, "\n  mov DWORD PTR [esp+16], 0%08xh\n", (UINT32) (Value & 0xFFFFFFFF)));  //Put the low 32bit of Value on stack
    DEBUG ((EFI_D_ERROR, "\n  mov DWORD PTR [esp+20], 0%08xh\n", (UINT32) (Value >> 32)));         //Put the high 32bit of Value on stack
    DEBUG ((EFI_D_ERROR, "\n  movq xmm0, QWORD PTR [esp+16]\n"));                                  //Move the 64bit Value from stack to xmm0
    DEBUG ((EFI_D_ERROR, "\n  movq QWORD PTR ds:[0%08xh], xmm0\n", Address));                      //64bit MMIO write

    DEBUG ((EFI_D_ERROR, "\n  vmovdqu xmm0, [esp]\n"));                                            //Restore the xmm0
    DEBUG ((EFI_D_ERROR, "\n  lea esp, [esp+24]\n"));                                              //Update the stack
  }

  return InternalMmioWrite64 (Address, Value);
}
