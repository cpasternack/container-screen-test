FROM ubuntu:18.04
LABEL maintainer="cpasternack@users.noreply.github.com"

# Install support packages
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends\
  screen \
  sudo \
  vim 
  
# Install OpenSSH server and allow X11 forwarding settings
# NOTE: THIS ALLOWS ROOT TO LOGIN VIA PASSWORD.
RUN apt-get install -y --no-install-recommends openssh-server &&\
  sed -i 's/session    required     pam_loginuid.so/session    optional     pam_loginuid.so/g' /etc/pam.d/sshd &&\
  # Change below to make more secure. Also add a user.
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config &&\
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config &&\
  #sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config &&\
  #sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config &&\
  sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config &&\
  #sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config &&\
  mkdir -p /var/run/sshd

# Cleanup old packages
RUN apt-get -y autoremove && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/*

# User management
# Set root password with some variation (i.e. Not secure)
RUN echo `date +'%m%y_%H%M%S'` >> /tmp/ROOTPW.txt &&\
  echo "root:`cat /tmp/ROOTPW.txt`" | chpasswd
SHELL ["/bin/bash", "--login", "-c"]

# Add support files
ADD entrypoint.sh /usr/bin/
ADD screenrc /etc/
# Standard SSH port
EXPOSE 22
# Entrypoint 
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["--help"]
