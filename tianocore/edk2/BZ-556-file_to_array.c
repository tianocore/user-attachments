/*
 * Copyright 2020 Intel Corporation
 * SPDX-License-Identifier: BSD-2-Clause-Patent
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>
#include <ctype.h>
#include <stdlib.h>

#define FPRINTF(fp, ...)					\
	do {							\
		if (0 > fprintf(fp, __VA_ARGS__)) {		\
			printf("fprintf() failed to write\n");	\
			goto err;				\
		}						\
	} while (0);

void help()
{
	printf("Usage:\n");
	printf("\n");
	printf(" --infile\n");
	printf("   input binary file to be converted to C array\n");
	printf(" --outfile\n");
	printf("   output header file which will contain C array\n");
}

int main(int argc, char *argv[])
{
	char infile[64];
	char outfile[64];
	char *inc_guard = NULL;
	char arrayname[64];
	char byte;
	char *dotptr;
	FILE *fin = NULL;
	FILE *fout = NULL;
	int count = 1;
	int option;
	int ret = -1;
	size_t size = 0;
	enum {
		INFILE,
		OUTFILE,
	};
	struct option longopt[] = {
		{"infile", 1, NULL, INFILE},
		{"outfile", 1, NULL, OUTFILE},
		{0, 0, 0, 0},
	};
	const char *copyright = "/*\r\n" \
		 " * Copyright 2020 Intel Corporation\r\n" \
		 " * SPDX-License-Identifier: BSD-2-Clause-Patent\r\n" \
		 " */\r\n";

	memset(&infile, 0, sizeof(infile));
	memset(&outfile, 0, sizeof(outfile));

	/* Parse the command line arguments */
	while ((option = getopt_long(argc, argv, "", longopt, NULL)) != -1) {
		switch (option) {
		case INFILE:
			size = strlen(optarg) >= sizeof(infile) ? sizeof(infile) - 1 : strlen(optarg);
			strncpy(infile, optarg, size);
			infile[size] = '\0';
			break;

		case OUTFILE:
			size = strlen(optarg) >= sizeof(outfile) ? sizeof(outfile) - 1 : strlen(optarg);
			strncpy(outfile, optarg, size);
			outfile[size] = '\0';
			break;

		default:
			help();
			goto err;
		}
	}
	
	if (!strlen(infile) || !strlen(outfile)) {
		help();
		goto err;
	}

	memset(arrayname, 0, sizeof(arrayname));

	/* Check if the first byte is alphabet */
	if (!isalpha(outfile[0])) {
		printf("First letter must be alphabet as it's going to be array name\n");
		goto err;
	}

	/* Count till last consecutive alpha numeric digit is there */
	while (count < strlen(outfile)) {
		if (!isalnum(outfile[count]) && outfile[count] != '_') {
			break;
		}
		count++;
	}

	/* Create the array with the name above */
	strncpy(arrayname, "char ", strlen("char "));
	strncat(arrayname, outfile, count);
	strncat(arrayname, "[] = {", strlen("[] = {"));

	/* Open the input file */
	fin = fopen(infile, "r");
	if (!fin) {
		printf("Failed to open %s\n", infile);
		goto err;
	}

	/* Open the output file */
	fout = fopen(outfile, "w");
	if (!fout) {
		printf("Failed to open %s\n", outfile);
		goto err;
	}

	/* Start with the copyright header */
	FPRINTF(fout, "%s", copyright);

	/* Insert the include guard */
	inc_guard = strdup(outfile);
	if (!inc_guard) {
		printf("Failed to duplicate string for include guard\n");
		goto err;
	}
	dotptr = strrchr(inc_guard, '.');
	if (dotptr)
		*dotptr = '_';

	for (count = 0; count < strlen(inc_guard); count ++) {
		inc_guard[count] = toupper(inc_guard[count]);
	}

	FPRINTF(fout, "#ifndef __%s__\r\n", inc_guard);
	FPRINTF(fout, "#define __%s__\r\n\n", inc_guard);

	/* Write the array name */
	FPRINTF(fout, "%s", arrayname);

	count = 1;
	FPRINTF(fout, "\r\n  ");
	while (fread(&byte, 1, 1, fin) == 1) {
		if (count % 16 != 0) {
			FPRINTF(fout, "0x%.2x, ", byte & 0xFF);
		} else {
			FPRINTF(fout, "0x%.2x,\r\n  ", byte & 0xFF);
		}
		count++;
	}

	FPRINTF(fout, "\r\n%s;\r\n", "}");
	FPRINTF(fout, "%s\r\n", "#endif");
	ret = 0;

err:
	if (inc_guard)
		free(inc_guard);
	if (fin)
		fclose(fin);
	if (fout)
		fclose(fout);
	return ret;
}
