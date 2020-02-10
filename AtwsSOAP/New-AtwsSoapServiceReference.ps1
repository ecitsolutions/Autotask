dotnet-svcutil 'https://webservices.Autotask.net/atservices/1.6/atws.wsdl' --sync --outputDir ./Autotask
Move-Item ./Autotask/Reference.cs ../Autotask/Private/Reference.cs -Force
# do not build. We try do build dynamically on load
# dotnet build