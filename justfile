#    <one line to give the program's name and a brief idea of what it does.>  
#    Copyright © 2024 Charudatta
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#    email contact: 152109007c@gmailcom

set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

env_path := "C:/Users/$env:username/Documents/GitHub"

default:
    @just --choose

# create files and directories
init:
    #!pwsh
    Initialize-Project

# add documentation to repo
docs:
    #!pwsh
    conda activate blog
    python -m mkdocs new .

# generate and readme to repo    
readme:
    #!pwsh
    conda activate w
    python {{env_path}}/readmeGen/main.py

# version control repo with git
commit message="init":
    #!pwsh
    git add .
    git commit -m {{message}}

# create windows executable
exe file_name:
    #!pwsh
    pyinstaller src/{{file_name}} --onefile

# run python unit test 
tests:
    #!pwsh
    python -m unittest discover -s tests

# run project
run:
    #!pwsh
    python run.py

# exit just file
quit:
    #!pwsh
    write-Host "Copyright © 2024 Charudatta"
    Write-Host "email contact: 152109007c@gmailcom"
    Write-Host "Exiting Folder" 
    [System.IO.Path]::GetFileName($(Get-Location))

# install dependencies
install:
    #!pwsh
    pip install -r requirements.txt

# lint code
lint:
    #!pwsh
    pylint src/
    flake8 src/

# format code
format:
    #!pwsh
    black src/

# run security checks
security:
    #!pwsh
    bandit -r src/

# build documentation
build-docs:
    #!pwsh
    mkdocs build

# deploy application
deploy:
    #!pwsh
    git pull origin main --force
    @test
    @security
    @lint
    @format
    @commit
    git push -u origin main

# setup logging
setup-logging:
    #!pwsh
    New-Item -ItemType "file" -Path "src/logging_config.py"
    Add-Content -Path "src/logging_config.py" -Value @'
import logging

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    handlers=[logging.FileHandler("app.log"),
                              logging.StreamHandler()])
logger = logging.getLogger(__name__)
'@

# view logs
view-logs:
    #!pwsh
    Get-Content -Path "app.log" -Tail 10

# clean up
clean:
    #!pwsh
    Remove-Item -Recurse -Force dist, build, *.egg-info

# check for updates
update:
    #!pwsh
    pip list --outdated

# project mangement add task and todos 
todos:
    #!pwsh
    wic

# Add custom tasks, enviroment variables





        

