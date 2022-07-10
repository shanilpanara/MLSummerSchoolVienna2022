# ESI-DCAFM-TACO-VDSP Summer School on "Machine Learning for Materials Hard and Soft"
11.07 - 22.07. 2022 in Vienna, Austria, [official website here](https://vds-physics.univie.ac.at/activities-benefits/activities/schools-academies/summer-school-2022/).

## Tuesday tutorial session

**Date**: 12.07.2022, 14:00 - 17:00 \
**Tutor**: Pavol Harar [(orcid)](https://orcid.org/0000-0001-5206-1794) \
**Title**: A tool a day keeps the bad review away \
**Slides**: [`presentation.pdf`](presentation.pdf)

The main aim of this session is to have a hands on experience with (some of) the tools presented in the slides. This session is not focused on data/modeling, etc. but rather on the technical aspects around your ML projects. Due to the number of participants, it is not possible to help everybody so in case you feel overwhelmed, do not feel guilty to just follow the presentation.

## Exercises

The following material builds on a Jupyter notebook in which a model was previously trained. The pre-trained model(s) are assumed to be stored and ready to use. In total, there are 7 exercises. Each of the exercises contains a rough (on purpose non-complete) guide to complete the assignment. Often, the project files themselves are the solution, so you can help yourself by peeking into them whenever you feel stuck. All the commands bellow are suited for Ubuntu operating system but links to relevant resources are provided for users of other operating systems.

By the end of the day, you should be able to:

1. run a machine learning project within a virtual environment on your own computer
2. put your code into a git repository like this one
3. specify, build, and run a Docker container which runs your project
4. track your experiments in a nice and useful web interface
5. wrap your project into an interactive web application for common users
6. configure your project to run on Binder, e.g. for reviewers of your paper
7. deploy the web application such that it is available from the Internet

----

### Exercise 1 - Jupyter in Virtualenv

The assignment: Run a Jupyter notebook server from within a virtual environment.

* Create a new `MLSummerSchoolVienna2022` folder (this will be the root of this project).
* Change director to your newly created project root folder.
* Download the `notebook.ipynb` file from this repository.
* Create a new empty file called `requirements.txt` and fill it with dependencies of `notebook.ipynb` (or just download it from the repository).
* Install `virtualenv` & create a virtual environment in `venv` folder (steps depend on your OS).
  In case you are more comfortable with Conda, feel free to use it instead of virtualenv.
* Install dependencies from `requirements.txt`. (The torch+cpu package is not available for Mac users, so in case you have a Mac, remove the first line of the `requirements.txt` where the `-f` flag is specified and adjust the lines of torch and torchvision to not mention cpu. The torch+cpu package should then later be used within the Docker based on Ubuntu and also on Binder and Heroku. Torch which supports both cpu and gpu computation is quite large ~1GB and Heroku would complain about the size quota. You can alternatively keep two version of the file, e.g. 1. `requirements.txt` and 2. `requirements-mac.txt`)
* Run the `jupyter notebook` server.
* Run the cell 1 to see whether all imports work.
* Create a readme.md file with just a name of the project.
* Optionally, train the model and save it as a file.
<!-- * If you run cells 1-4 the data will be downloaded into `data` folder which is needed only when you want to train the network. In the following exercises we will only need the pre-trained models, so download them from the repository into the root of your project. -->

----

### Exercise 2 - Git

The assignment: Create a new repository for this project and push an initial commit into it.

#### Make sure you can authenticate with git using ssh key

* Create an account on github.com.
* Go to `github.com > settings > SSH and GPG keys`.
* Copy your public ssh key from the output of `cat ~/.ssh/id_rsa.pub` (depends on your OS).
* Add it to the github keys and verify with `ssh -T git@github.com`.
* In case of different OS or some problems consult the [github guide](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection).

#### Create a new repository, initialize & push your project to origin

* Go to github.com and create a new repository called `MLSummerSchoolVienna2022` (change the name of the repository to your liking but do not forget to change it in some of the commands bellow).
* Do not check the automatic creation of readme, license or other files.
* Go to your project root folder.
* Create `.gitignore` file with `venv`, `.ipynb_checkpoints` in it.
* Run `git init`.
* Run `git remote add origin git@github.com:<your_username>/MLSummerSchoolVienna2022.git`.
* If you use `git` for the first time, you might be asked to configure your user name and commit email address with:
  * Run `git config --global user.name "Your Name"`.
  * Run `git config --global user.email "Your Name"`.
* Run `git add .`.
* Run `git commit -m "Initial commit"`.
* Run `git push origin main`.
* Now your changes should be visible in your repository on github.com.
* In case your HEAD branch is not called `main` but `master`, change the commands accordingly to avoid problems.

#### More in-depth but still absolutely simple guide on git:

* https://rogerdudler.github.io/git-guide/

----

### Exercise 3 - Docker

The assignment: Run a Jupyter notebook server in a Docker container.

#### Install Docker

* If you use different OS than Ubuntu, check [Docker installation guide](https://docs.docker.com/engine/install/).
* On Ubuntu install with `sudo apt install docker.io`
* Check if it is installed correctly with `sudo docker run hello-world`

#### Pull Ubuntu minimal docker image

* Run `sudo docker pull intelliseqngs/ubuntu-minimal-20.04:3.0.5`.
* Add a file `.dockerfile` into your project. (Here we use a nonstandard name for a reason that we actually do not want Binder and Heroku to use our Dockerfile.)
* Base your `.dockerfile` on `intelliseqngs/ubuntu-minimal-20.04:3.0.5`.
* Fill the `.dockerfile` with commands to copy and install your project.
* Reference on writing the Dockerfile is [here](https://docs.docker.com/engine/reference/builder/).
* In case you have problems, consult the solution in [.dockerfile](.dockerfile).

#### Build the image

* Run `sudo docker build -t mlssv2022:latest -f .dockerfile .`.
* In case your Docker errors on "killed" Adjust Docker Preferences Resources RAM - make it bigger, i.e. 4 or 6GB in the settings of your Docker.
* Run `sudo docker run --rm -p 8888:8888 mlssv2022:latest jupyter notebook --allow-root --ip 0.0.0.0`.
  * `-p` forwards port 8888 of the container to 8888 on the host
  * `--allow-root` since all in the container runs as root
  * `--ip 0.0.0.0` expose the jupyter server so host can see it
* Visit `localhost:8888` in your browser and copy the token, the jupyter notebook should now run.

<!-- * Run `sudo docker run --rm -v <path_on_host_to_your_project_root>/data:/home/data -p 8888:8888 mlssv2022:latest jupyter notebook --allow-root --ip 0.0.0.0`.
  * `-p` forwards port 8888 of the container to 8888 on the host
  * `-v` mounts specified host folder to container's folder (paths must be absolute) -->
----

### Exercise 4 - Weights and Biases

The assignment: Run and explore the wandb examples.
Optional assignment: Adjust `notebook.ipynb` such that training is tracked in wandb.

* Create an account at wandb.ai.
* Log in to your account and try the Example (wandb.me/intro) and run it until the "Run experiment" cell finishes.
* Check the results in the wandb.ai account.
* Check also these examples https://github.com/wandb/examples.
* If you feel motivated, change the `notebook.ipynb` such that it tracks the training into wandb and view the results in the web interface.

----

### Exercise 5 - Voila [slightly optional]

The assignment: Create a simple interactive webapp using ipywidgets and Voila.
Optional assignment: Make the app run in Docker container.

* Go back to the notebook which is running in virtual environment.
* Create a new python3 notebook called `webapp.ipynb`.
* Make sure you trained the model or downloaded the pre-trained model(s) from the repository to the project root.
* Build a simple interactive webapp using [ipywidgets](https://ipywidgets.readthedocs.io/en/latest/) which allows the user to input data (e.g. as an URL to a file), then loads a pre-trained model, and finally it computes and displays the prediction to the user.
* Click on Voila button in the Jupyter notebook menu to test whether everything runs as a web app.
* If you wish to have a functional Docker container with a webapp inside, update the `.dockerfile` to include web app related files (`webapp.ipynb` and pre-trained model(s)) and rebuild your Docker image.
* Push your changes to git.

----

### Exercise 6 - Binder [moderately optional]
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/paloha/MLSummerSchoolVienna2022/main?urlpath=%2Fvoila%2Frender%2Fwebapp.ipynb)

* Make your git repo public if it is not already.
* Go to [mybinder.org](https://mybinder.org) and fill in the form:
  * Repository URL: `https://github.com/<your_username>/mlssv2022`
  * Git ref: `main` (or `master` depending on your repo)
  * Path to a **URL** (not a file): `/voila/render/webapp.ipynb`
* Copy the binder markup badge into your `readme.md`.
* Wait for app to run in Binder. It will take quite some time, but Binder is a free service, so...
* Check how to use Docker with binder if needed [here](https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html).
* When the app runs, have fun...
<!-- You can try this [image](https://m.media-amazon.com/images/I/81U64AnQvkL._AC_UL1500_.jpg) for example. -->

\*An example badge to run the webapp from this repository on Binder is bellow the title of this exercise. Try to click it.

----

### Exercise 7 - Heroku [very optional]

* Create a free account on Heroku. It might still ask you to fill in your credit card though.
* Add `Procfile` with `web: voila webapp.ipynb --no-browser --port $PORT`.
* Add `runtime.txt` into project folder with `python-3.8.10`.
* Push changes to the repo.
* Install Heroku cli by following [the official guide](https://devcenter.heroku.com/articles/heroku-cli#download-and-install).
* Deploy your app to heroku using git:
  * Run `heroku update` to make sure Heroku cli is up to date
  * Run `heroku create` to create a new Heroku app
  * Run `git push heroku master` to deploy.
  * Optionally set `heroku ps:scale web=1`.
  * Openy your app with `heroku open`.
* Or follow [the deployment guide](https://voila.readthedocs.io/en/stable/deploy.html#deployment-on-heroku) directly from Voila.

----

### Some useful links
* [How to use Docker with GPU](https://towardsdatascience.com/4c699c78c6d1)
* [Example on how to better structure the project](https://gitlab.com/paloha/repex-template)
* [Free Heroku slug must be at most 500MB](https://help.heroku.com/KUFMEES1/my-slug-size-is-too-large-how-can-i-make-it-smaller)
