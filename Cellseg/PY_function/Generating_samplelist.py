# python3
# -*- coding: utf-8 -*- 

import os
import glob
import re
import csv
import argparse

def generate_csv(input_folder, output_csv_path='/mnt/Sample_list.csv'):
    raw_path = os.path.abspath(input_folder)
    output_path = '/mnt/results'

    # Find all .mcd files
    mcd_files = glob.glob(os.path.join(raw_path, "*.mcd"))
    if not mcd_files:
        raise FileNotFoundError("❌ No .mcd files found in the input folder.")

    # Find the metadata CSV file using regex (grepl-style)
    all_csv_files = glob.glob(os.path.join(raw_path, "*.csv"))
    metadata_files = [f for f in all_csv_files if re.search(r"metadata", os.path.basename(f), re.IGNORECASE)]

    if len(metadata_files) == 0:
        raise FileNotFoundError("❌ No metadata*.csv file found in the input folder.")
    elif len(metadata_files) > 1:
        raise ValueError("❌ Multiple metadata CSV files found. Only one expected.")
    else:
        metadata_file = metadata_files[0]

    # Write CSV rows
    rows = []
    for mcd_file in mcd_files:
        rows.append({
            "raw_file_path": mcd_file,
            "metafile_path": metadata_file,
            "output_path": output_path
        })

    # Write to CSV file
    with open(output_csv_path, mode="w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=["raw_file_path", "metafile_path", "output_path"])
        writer.writeheader()
        writer.writerows(rows)

    print(f"✅ CSV generated: {output_csv_path}")
    print(f"🔢 Total MCD files listed: {len(rows)}")
    print(f"📄 Metadata file used: {metadata_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate CSV mapping of MCD input files.")
    parser.add_argument("input_folder", help="Folder containing .mcd and metadata*.csv files (e.g. /mnt/Raw)")
    args = parser.parse_args()

    generate_csv(args.input_folder)



# Example usage:
# python generate_file_paths.py /mnt/Raw
