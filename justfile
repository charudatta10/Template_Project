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
    try {
        .\New-Project.ps1
    } catch {
        Write-Error "Failed to initialize the project: $_"
    }

# add documentation to repo
docs:
    #!pwsh
    conda activate blog
    if ($?) {
        python -m mkdocs new .
    } else {
        Write-Error "Failed to activate conda environment 'blog'"
    }

# generate and readme to repo    
readme:
    #!pwsh
    conda activate w
    if ($?) {
        python {{env_path}}/readmeGen/main.py
    } else {
        Write-Error "Failed to activate conda environment 'w'"
    }

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
    just install
    conda activate webdev
    if ($?) {
        python -m unittest discover -s tests
    } else {
        Write-Error "Failed to activate conda environment 'webdev'"
    }

# run project
run:
    #!pwsh
    python run.py

# exit just file
quit:
    #!pwsh
    Write-Host "Copyright © 2024 Charudatta"
    
# install dependencies
install:
    #!pwsh
    pip install -r requirements.txt

# lint and format code
lint-format:
    #!pwsh
    pylint src/
    flake8 src/
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
    just tests
    just security
    just lint-format
    just commit
    git push -u origin main

# setup logging
setup-logging:
    #!pwsh
    .\Add-Logger.ps1

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

# project management add task and todos 
todos:
    #!pwsh
    wic

timeit cmd="start":
    #!pwsh
    timetrace {{cmd}} # start, stop, list

# setup environment
setup-environment:
    #!pwsh
    conda create --name myenv python=3.9

# deploy production environment
deploy-production:
    #!pwsh
    just setup-environment
    just install
    just tests
    just security
    just lint-format
    just build-docs
    just commit
    git push -u origin main

# Add custom tasks, enviroment variables





        

