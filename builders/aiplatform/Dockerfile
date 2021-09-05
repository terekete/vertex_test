FROM python

COPY . .

# Download and install required tools.
RUN pip3 install --upgrade google-cloud-aiplatform
RUN pip3 install --upgrade Cerberus

ENTRYPOINT [ "python" ]