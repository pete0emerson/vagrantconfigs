class natty {
  exec {
    "python-software-properties":
      command => "/usr/bin/apt-get -y install python-software-properties",
      logoutput => true;
    "add-lucid-repo":
      require => Exec["python-software-properties"],
      command => "/usr/bin/apt-add-repository 'deb http://archive.canonical.com/ lucid partner'",
      logoutput => true;
    "apt-get -y-update":
      require => Exec["add-lucid-repo"],
      command => "/usr/bin/apt-get -y update",
      logoutput => true;
    "install-sun-java6-jre":
      require => Exec["apt-get -y-update"],
      command => "/bin/echo 'sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true' | debconf-set-selections ; /usr/bin/apt-get -y install sun-java6-jre",
      logoutput => true;
  }
}

include natty
