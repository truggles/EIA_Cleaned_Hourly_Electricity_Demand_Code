FROM ubuntu:trusty-20191217



RUN apt-get install -y wget unzip

WORKDIR /src

# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.10-Linux-x86_64.sh
RUN bash Anaconda3-2019.10-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.10-Linux-x86_64.sh


# Set path to conda
ENV PATH /root/anaconda3/bin:$PATH


# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml
RUN echo "source activate data_cleaning_env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH


# Make RUN commands use the new environment:
#SHELL ["conda", "run", "-n", "data_cleaning_env", "/bin/bash", "-c"]



## Configuring access to Jupyter
#RUN mkdir /opt/notebooks
#RUN jupyter notebook --generate-config --allow-root
#
## Password is 'pwd' and sha1 is generated with
## $ ipython
## In [1]: from notebook.auth import passwd
## In [2]: passwd()
#RUN echo "c.NotebookApp.password = u'sha1:a7d69d557da4:a9282edebf65975f32e1f6e119604818cf4a31d5'" >> /root/.jupyter/jupyter_notebook_config.py
#
#
#
## Jupyter listens port: 8888
#EXPOSE 8888






# The code to run when container is started:
COPY step1_get_eia_demand_data.ipynb .
COPY step2_anomaly_screening.ipynb .
COPY step3_MICE_imputation.ipynb .
COPY step4_distribute_MICE_results.ipynb .
COPY MICE_step.Rmd .
COPY check_reproducibility.sh .
#ENTRYPOINT ["conda", "run", "-n", "data_cleaning_env", "jupyter", "notebook"]
#ENTRYPOINT ["jupyter", "notebook"]
# Run Jupyter notebook as Docker main process
CMD ["ls"]
#CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/src", "--ip='*'", "--port=8888", "--no-browser"]
#CMD ["jupyter", "notebook", "--notebook-dir=/src", "--ip='*'", "--port=8888"]
#ENTRYPOINT ["jupyter", "notebook", "--notebook-dir=/src", "--ip='*'", "--port=8888"]

