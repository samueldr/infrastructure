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
