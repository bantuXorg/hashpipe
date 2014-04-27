#!/bin/sh
# This file is part of hashpipe by Andreas Fischer <af@bantuX.org>.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

SCRIPT=$(basename "$0")
if [ "$#" -ne 1 ]; then
    echo "Description: Writes stdin data to file while producing a sha256 checksum file." >&2
    echo "      Usage: ... | $SCRIPT /path/to/outfile" >&2
    echo "     Verify: sha256sum --check /path/to/outfile.sha256" >&2
    exit 1
fi

FILE="$1"
FILE_HASH="$FILE.sha256"
FILE_BASE=$(basename "$FILE")

if [ -e "$FILE" ]; then
    echo "Output file $FILE already exists." >&2
    exit 1
fi

if [ -e "$FILE_HASH" ]; then
    echo "Hash file $FILE_HASH already exists." >&2
    exit 1
fi

CHECKSUM=$(tee "$FILE" < /dev/stdin | sha256sum | awk '{print $1}')
echo "$CHECKSUM  $FILE_BASE" > "$FILE_HASH"
