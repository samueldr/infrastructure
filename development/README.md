`rabbitmq`
==========

I want to login as an admin
---------------------------

The development environment creates a default insecure `admin` user with the password `admin`.

Use the web interface here:

 * http://localhost:15672


I want to create a local admin user
-----------------------------------

As root:

```
RABBITMQ_USE_LONGNAME=true HOME=/var/lib/rabbitmq rabbitmqctl add_user test test
RABBITMQ_USE_LONGNAME=true HOME=/var/lib/rabbitmq rabbitmqctl set_user_tags test administrator
RABBITMQ_USE_LONGNAME=true HOME=/var/lib/rabbitmq rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
```

Then you should be able to login the web interface using test, test

 * http://localhost:15672


`webhook`
=========

> Impurity ??!? in my ofborg??

The current webhook code has slight impurities.

You will need to (on your local computer or the VM) run this in the php folder
of the `ofborg` project.

```
nix-shell -p phpPackages.composer --run "composer install"
```

Accessing `http://localhost:8080/webhook/` and getting `InvalidPayloadException` is success.
