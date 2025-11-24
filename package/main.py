from io import TextIOWrapper
from typing import *
import os
import subprocess
import shutil

PROJECT_CONFIG_PATH = '../pubspec.yaml'
INSTALLATION_PATH = "./usr/lib/timeliner"
METADATA_PATH = "./DEBIAN"
METADATA_FILE_PATH = f"{METADATA_PATH}/control"
BINARY_FILE_NAME = ""
BINARY_PATH = "./usr/local/bin"

def getProperty(path: str, identifier: str):
    file = open(path, "+r")
    for line in file.readlines():
        if line.startswith(identifier):
            value = (line[line.index(":")+1::]).strip()
            return value


        
def createProjectRoot():
    for dir in [INSTALLATION_PATH, METADATA_PATH]:
        try:
            os.makedirs(dir)
        except Exception as e:
            if (os.path.isdir(dir)):
                print(f'{dir} exists. Creation skipped')
            else:
                print(f"Failed to create {dir} with error: {e}")
                exit()

    open(f"{METADATA_FILE_PATH}", "w")

def compileProject() -> str:
    build = subprocess.run(
        ['flutter', 'build', 'linux' ,'--release'], 
        capture_output=True,
        text=True,
        cwd=".."
    )
    print(build.stdout)
    stdout = [x for x in (build.stdout).split("\n") if len(x) > 0]
    
    global BINARY_FILE_NAME
    binary_dir = stdout[-1][( stdout[-1].index("Built")+len("Built")):: ].strip()
    BINARY_FILE_NAME = (binary_dir).split("/")[-1]
    print(f"Setting BINARY_FILE_DIRECTORY to {BINARY_FILE_NAME}")



    binary_dir = "/".join(binary_dir.split("/")[:-1])
    print(f"Copying from ../{binary_dir} to {INSTALLATION_PATH}")

    for file in os.listdir(f"../{binary_dir}"):
        full_path_to_file = os.path.join(f"../{binary_dir}", file)
        print(f"Copying {full_path_to_file} to {INSTALLATION_PATH}")
        if (os.path.isfile(full_path_to_file)):
            shutil.copy(full_path_to_file, INSTALLATION_PATH)
        else:
            shutil.copytree(full_path_to_file, f"{INSTALLATION_PATH}/{file}")

def createEntryPoint():
    contents = f"""
#!/bin/sh
exec {INSTALLATION_PATH.replace(".", "", count=1)}/{BINARY_FILE_NAME} \"$@\"
"""
    try:
        os.makedirs(BINARY_PATH)
    except:
        pass

    file = open(f"{BINARY_PATH}/{BINARY_FILE_NAME}", "w")
    file.write(contents)

    subprocess.run(list((f"sudo chmod +x {BINARY_PATH}/{BINARY_FILE_NAME}").split(" ")))


def generateMetadata():
    metadata_file = open(METADATA_FILE_PATH, "w")
    contents = f"""
Package: {project_name}
Version: {project_version}
Section: base
Priority: optional
Architecture: amd64
Depends: 
Maintainer: Alcalino <alanhumber333@gmail.com>
Description: {project_description.replace("\"", "")}
"""
    metadata_file.write(contents)

def buildDebPackage():
    try:
        os.makedirs(package_name)
    except Exception as e:
        if not (os.path.isdir(package_name)):
            print(f"Failed to create package dir: {e}")
            return
    
    for dir in os.listdir("."):
        if not os.path.isdir(dir):
            continue
        shutil.move(dir, package_name)


    
    subprocess.run(["dpkg-deb", "--build", package_name ])


def process_cleanup():
    for dir in os.listdir("."):
        if not os.path.isdir(dir):
            continue
        shutil.rmtree(dir)


if __name__ == "__main__":
    cwd = os.getcwd()
    script_path = os.path.realpath(__file__)

    files = [ f"{cwd}/{x}" for x in os.listdir(cwd)  ]
    #print(files)


    if script_path not in files:
        print("This script is meant to be executed from its own directory")
        print(f"Expected current working directory to be the same directory as \n{script_path}\nbut got\n{cwd}")
        print("Exiting...")
        exit(1)

    try:
        project_version = getProperty(PROJECT_CONFIG_PATH, "version")
        project_name = (getProperty(PROJECT_CONFIG_PATH, "name")).replace("_", "").replace("flutter", "")
        project_description = getProperty(PROJECT_CONFIG_PATH, "description")
        package_name = f"./{project_name}_{project_version}-1"


        createProjectRoot() #Creates files where flutter blobs will be moved

        compileProject() #Actually builds the flutter project. Also moves the blob to the appropiate local directories
        createEntryPoint() #Creates a binary file in /usr/local/bin to call the actual entry point

        generateMetadata() #Generates deb metadata

        buildDebPackage() #Generates the actual deb package
    except Exception as e:
        print(e)
    finally:
        process_cleanup() #Deletes all creates files except the deb package itself
        pass

