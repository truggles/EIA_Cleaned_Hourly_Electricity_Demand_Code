import os
import filecmp
import difflib
import shutil
import git

def compare_files(original_dir, new_dir):
    """Compare files between original and new directories."""
    original_files = os.listdir(original_dir)
    new_files = os.listdir(new_dir)

    # Compare number of files
    if len(original_files) != len(new_files):
        print("\nNumber of files differ between original and new directories.")
        print(f"Original: {len(original_files)} files")
        print(f"New: {len(new_files)} files")
    else:
        print("Number of files match between original and new directories")

    # Check if all original files exist in the new directory
    missing_files = [file for file in original_files if file not in new_files]
    if missing_files:
        print("\nMissing files in new directory:")
        for file in missing_files:
            print(file)
    else:
        print("All files from the original directory exist in the new directory.")

    # Compare contents of each file
    n_files_diff = 0
    for file in original_files:
        if file in new_files:
            original_file_path = os.path.join(original_dir, file)
            new_file_path = os.path.join(new_dir, file)
            if filecmp.cmp(original_file_path, new_file_path, shallow=False):
                print(f"Files are identical: {file}")
            else:
                print(f"\nFiles differ: {file}")
                with open(original_file_path, 'r') as orig_file, open(new_file_path, 'r') as new_file:
                    orig_lines = orig_file.readlines()
                    new_lines = new_file.readlines()
                    # Find the first line that differs and print the original line and new line
                    for il, line in enumerate(orig_lines):
                        if line != new_lines[il]:
                            print(f"First differing line: {il}")
                            print(f"Original: {line}", f"New: {new_lines[il]}")
                            break
                n_files_diff += 1
        else:
            print(f"File not found in new directory: {file}")
    print("{} files differ between original and new directories.".format(n_files_diff))

def clone_repository(repo_url, clone_dir):
    """Clone the repository to a local directory."""
    if os.path.exists(clone_dir):
        shutil.rmtree(clone_dir)
    git.Repo.clone_from(repo_url, clone_dir)

if __name__ == "__main__":
    repo_url = "https://github.com/truggles/EIA_Cleaned_Hourly_Electricity_Demand_Data.git"  
    clone_dir = "EIA_Cleaned_Hourly_Electricity_Demand_Data"
    original_directory = "EIA_Cleaned_Hourly_Electricity_Demand_Data/data/release_2020_Oct/original_eia_files/"
    new_directory = "data/"

    # Clone the repository
    clone_repository(repo_url, clone_dir)

    # Compare files
    compare_files(original_directory, new_directory)

    # Clean up the cloned repository
    shutil.rmtree(clone_dir)
