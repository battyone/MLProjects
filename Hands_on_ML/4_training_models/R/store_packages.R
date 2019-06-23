tmp.pkg.list <- installed.packages()

installedpackages <- as.vector(tmp.pkg.list[is.na(tmp.pkg.list[,"Priority"]), 1]) 

save(installedpackages, file="~/Downloads/installed_packages.rda")