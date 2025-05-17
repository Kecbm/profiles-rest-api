FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3-venv zip && \
    apt-get clean

RUN touch /root/.bash_aliases && \
    grep -q 'PYTHON_ALIAS_ADDED' /root/.bash_aliases || echo "\
# PYTHON_ALIAS_ADDED\n\
alias python='python3'" >> /root/.bash_aliases

EXPOSE 8000

CMD ["/bin/bash"]
