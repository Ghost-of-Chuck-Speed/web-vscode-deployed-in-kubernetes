#!/bin/bash

# Function to compress and encrypt a directory
encrypt_directory() {
    local DIRECTORY=$1
    local BASENAME=$(basename "$DIRECTORY")

    # Compress the directory using tar
    tar -czf "${BASENAME}.tar.gz" "$DIRECTORY"

    # Encrypt the compressed file using gpg with --no-symkey
    gpg --no-symkey-cache -c "${BASENAME}.tar.gz"

    # Remove the unencrypted tar file
    rm "${BASENAME}.tar.gz"

    echo "Directory '$DIRECTORY' has been compressed and encrypted to '${BASENAME}.tar.gz.gpg'."
}

# Function to decrypt and unzip a file
decrypt_file() {
    local ENCRYPTED_FILE=$1
    local BASENAME="${ENCRYPTED_FILE%.gpg}"

    # Decrypt the file
    gpg -d "$ENCRYPTED_FILE" > "${BASENAME}.tar.gz"

    # Unzip the tar file
    tar -xzf "${BASENAME}.tar.gz"

    # Optionally, remove the decrypted tar file
    rm "${BASENAME}.tar.gz"

    echo "File '$ENCRYPTED_FILE' has been decrypted and extracted."
}

# Parse options
while getopts ":e:d:" opt; do
    case ${opt} in
        e )
            encrypt_directory "$OPTARG"
            ;;
        d )
            decrypt_file "$OPTARG"
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            echo "Usage: $0 -e <directory> | -d <encrypted_file>"
            exit 1
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            echo "Usage: $0 -e <directory> | -d <encrypted_file>"
            exit 1
            ;;
    esac
done

# Check if no options were provided
if [ "$OPTIND" -eq 1 ]; then
    echo "Usage: $0 -e <directory> | -d <encrypted_file>"
    exit 1
fi
