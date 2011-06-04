class natty {
  exec {
    "jenkins-key":
      command => "/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -";
    "add-jenkins-debian-repo":
      require => Exec["jenkins-key"],
      command => "/bin/echo 'deb http://pkg.jenkins-ci.org/debian binary/' > /etc/apt/sources.list.d/jenkins.list";
    "aptitude-update":
      require => Exec["add-jenkins-debian-repo"],
      command => "/usr/bin/aptitude update";
    "apache-proxy":
      require => File["/etc/apache2/sites-available/jenkins"],
      command => "/usr/sbin/a2enmod proxy ; /usr/sbin/a2enmod proxy_http ; /usr/sbin/a2enmod vhost_alias ; /usr/sbin/a2dissite default ; /usr/sbin/a2ensite jenkins",
      notify => Service["apache2"];
  }
  package {
    "apache2":
      require => Exec["aptitude-update"],
      ensure => present;
    "jenkins":
      require => Package["apache2"],
      ensure => present;
  }
  file {
    "/etc/apache2/sites-available/jenkins":
        require => Package["jenkins"],
        ensure => file,
        owner => root,
        group => root,
        mode => 0644,
        source => "/vagrant/puppetfiles/etc-apache2-sites-available-jenkins",
        notify => Service["apache2"]
  }
  service {
    "apache2":
      require => File["/etc/apache2/sites-available/jenkins"],
      ensure => running,
      enable => true;
    "jenkins":
      require => File["/etc/apache2/sites-available/jenkins"],
      ensure => running,
      enable => true;
  }
}

include natty
