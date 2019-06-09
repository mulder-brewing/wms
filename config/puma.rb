threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count


# Not sure if I need these lines for production, it breaks development though
# bind "unix:///var/run/puma.sock?umask=0000"
# stdout_redirect "/var/log/puma.stdout.log", "/var/log/puma.stderr.log", true

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV') { 'development' }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
