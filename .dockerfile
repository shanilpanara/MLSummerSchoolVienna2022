FROM intelliseqngs/ubuntu-minimal-20.04:3.0.5
WORKDIR /home/project
COPY requirements.txt notebook.ipynb webapp.ipynb pretrained_lr.model pretrained_nb.model ./
RUN pip3 install -r requirements.txt
CMD ["/bin/bash"]
