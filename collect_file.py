import os
import shutil
from collections import defaultdict

def collect_files(input_dir, output_dir):
    if not os.path.isdir(input_dir):
        print(f"Error: Input directory '{input_dir}' does not exist.")
        return

    os.makedirs(output_dir, exist_ok=True)


    file_count = defaultdict(int)


    for root, _, files in os.walk(input_dir):
        for file in files:
        
            original_file_path = os.path.join(root, file)
            file_ext = os.path.splitext(file)[1]
            file_name = os.path.splitext(file)[0]

            unique_name = file
            while os.path.exists(os.path.join(output_dir, unique_name)):
                file_count[file] += 1
                unique_name = f"{file_name}_{file_count[file]}{file_ext}"

           
            shutil.copy2(original_file_path, os.path.join(output_dir, unique_name))

    print(f"All files have been successfully collected in '{output_dir}'.")


