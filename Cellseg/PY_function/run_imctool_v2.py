import os
import sys
import argparse
import re

from imctools.io.mcd.mcdparser import McdParser
#from imctools.io.txt import TxtParser
from imctools.io.ometiff.ometiffparser import OmeTiffParser



def validate_roi(acquisition_id, parser):
    try:
        _ = parser.get_acquisition_data(acquisition_id)
        print(f'Roi {acquisition_id} valid')
        return True
    except Exception as e:
        print(f'roi-{acquisition_id} Not valid acquisition. {str(e)}')
        return False

def parse_args():
    parser = argparse.ArgumentParser(
        description='Split nf-core/imcyto input data by full/ilastik stack.',
        epilog="Example usage: python run_imctools.py <MCD/TXT/TIFF> <METADATA_FILE>"
    )
    parser.add_argument('INPUT_FILE', help="Input files with extension '.mcd'")
    parser.add_argument('METADATA_FILE', help="Metadata CSV with header: metal,full_stack,mccs_stack,nuclear,spillover,counterstain.")
    # add output directory
    parser.add_argument('OUTPUT_DIR', help="Output directory to save results.")
    parser.add_argument('SAVE_STACKS', type=bool, help="Save stacks as OME-TIFFs (True/False)")
    return parser.parse_args()

def main():
    args = parse_args()
    file_type = os.path.splitext(args.INPUT_FILE)[1].lower()
  
    Slide_ID=os.path.basename(args.INPUT_FILE).split('.')[0]
 
    # Create working directory by creeating a new folder up_up_folder and the Slide_ID
    working_directory = os.path.join(args.OUTPUT_DIR,Slide_ID)
    print(f"Working directory: {working_directory}")
    if not os.path.exists(working_directory):
        os.makedirs(working_directory)
        print(f"Created directory: {working_directory}")
    os.chdir(working_directory)
    print(f"Current working directory: {working_directory}")

    # HEADER for metadata
    # The metadata file should have at least 4 columns: 'metal', 'full_stack', 'nuclear', "counterstain" if it is for single cell analysis
    # seacrch colmns in the metadata file to get header
    with open(args.METADATA_FILE, 'r') as f:
             HEADER = f.readline().strip().split(',')
   
    #HEADER = ['metal', 'full_stack', 'mccs_stack', 'nuclear', 'spillover', 'counterstain']
    metalDict = {}

    # Validate metadata
    with open(args.METADATA_FILE, 'r') as f:
        header = f.readline().strip().split(',')
        if header != HEADER:
            print(f"ERROR: Metadata header mismatch.\nExpected: {HEADER}\nFound: {header}")
            sys.exit(1)

        for line in f:
            parts = line.strip().split(',')
            if len(parts) != len(HEADER):
                print(f"ERROR: Metadata row should have 6 columns!\n{line}")
                sys.exit(1)

            metal, *flags = parts
            if not all(flag in ['0', '1'] for flag in flags):
                print(f"ERROR: Metadata flags must be 0 or 1!\n{line}")
                sys.exit(1)

            metalDict[metal.upper()] = [bool(int(x)) for x in flags]

    roi_map = open(os.path.basename(args.INPUT_FILE)+'_ROI_map.csv', "w")

    if file_type == ".mcd":
        parser = McdParser(args.INPUT_FILE)
        acquisition_ids = parser.session.acquisition_ids
  
    else:
        print("ERROR: Unsupported file format. Use .mcd")
        sys.exit(1)

    for acq_id in acquisition_ids:
        if file_type == ".mcd":
            if not validate_roi(acq_id, parser):
                continue

            acq_data = parser.get_acquisition_data(acq_id)
            acq_meta = parser.session.acquisitions[acq_id]
            acq_slide = parser.session.slides[acq_meta.slide_id]
            print(f"Processing acquisition: {acq_id} - {acq_slide.name}")
            print(f"Slide name: {acq_slide.name}")
            roi_label = acq_meta.description
            roi_map.write(f"roi_{acq_id},{roi_label}\n")

        else:
            print("ERROR: Unsupported file format. Use .mcd")
            sys.exit(1)

        # Loop through each stack category
        for idx, category in enumerate(HEADER[1:]):
            print(f"Processing stack: {category}")
            dirname = os.path.join(f"roi_{acq_id}", category)
            os.makedirs(dirname, exist_ok=True)

            # Filter metals for this stack
            label_indices = [
                i for i, label in enumerate(acq_data.channel_labels)
                if any(label.upper().startswith(k) and metalDict[k][idx] for k in metalDict)
            ]

          
            metals_to_include=[acq_data.channel_names[i] for i in label_indices ]
            print(metals_to_include)
            if args.SAVE_STACKS and metals_to_include:
                out_path = os.path.join(f"roi_{acq_id}", f"{category}.ome.tiff")
                acq_data.save_ome_tiff(out_path, names=metals_to_include)

            acq_data.save_tiffs(dirname,names=metals_to_include, compression='zlib', bigtiff=False)
           

    roi_map.close()
    if file_type == ".mcd":
        parser.close()

if __name__ == "__main__":
    main()