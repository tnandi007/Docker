#FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /source

# copy csproj and restore as distinct layers
# COPY *.csproj ./
#COPY SPHE.GET.sln ./
COPY SPHE.CT/*.csproj ./SPHE.CT/

COPY SPHE.CT.Common/*.csproj ./SPHE.CT.Common/
COPY SPHE.CT.AppServices/*.csproj ./SPHE.CT.AppServices/
COPY SPHE.CT.BO.Admin/*.csproj ./SPHE.CT.BO.Admin/
COPY SPHE.CT.BO.Customer/*.csproj ./SPHE.CT.BO.Customer/
COPY SPHE.CT.BO.DigitalPromoPlanner/*.csproj ./SPHE.CT.BO.DigitalPromoPlanner/
COPY SPHE.CT.BO.NewRelease/*.csproj ./SPHE.CT.BO.NewRelease/
COPY SPHE.CT.BO.PostMartemReport/*.csproj ./SPHE.CT.BO.PostMartemReport/
COPY SPHE.CT.BO.Product/*.csproj ./SPHE.CT.BO.Product/
COPY SPHE.CT.BO.Promo/*.csproj ./SPHE.CT.BO.Promo/
COPY SPHE.CT.BO.PromoPlanner/*.csproj ./SPHE.CT.BO.PromoPlanner/
COPY SPHE.CT.BO.Report/*.csproj ./SPHE.CT.BO.Report/
COPY SPHE.CT.RestClient/*.csproj ./SPHE.CT.RestClient/
WORKDIR /source/SPHE.CT
#RUN dotnet restore
RUN dotnet restore "SPHE.CT.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.Common
RUN dotnet restore "SPHE.CT.Common.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.AppServices
RUN dotnet restore "SPHE.CT.AppServices.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.Admin
RUN dotnet restore "SPHE.CT.BO.Admin.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.Customer
RUN dotnet restore "SPHE.CT.BO.Customer.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.DigitalPromoPlanner
RUN dotnet restore "SPHE.CT.BO.DigitalPromoPlanner.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.NewRelease
RUN dotnet restore "SPHE.CT.BO.NewRelease.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.PostMartemReport
RUN dotnet restore "SPHE.CT.BO.PostMartemReport.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.Product
RUN dotnet restore "SPHE.CT.BO.Product.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.Promo
RUN dotnet restore "SPHE.CT.BO.Promo.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.PromoPlanner
RUN dotnet restore "SPHE.CT.BO.PromoPlanner.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.BO.Report
RUN dotnet restore "SPHE.CT.BO.Report.csproj" --use-current-runtime

WORKDIR /source/SPHE.CT.RestClient
RUN dotnet restore "SPHE.CT.RestAPIClient.csproj" --use-current-runtime

# #--use-current-runtime
WORKDIR /source
# # copy everything else and build app
COPY SPHE.CT/. ./SPHE.CT/
#COPY . ./
#COPY . .
COPY SPHE.CT.Common/. ./SPHE.CT.Common/
COPY SPHE.CT.AppServices/. ./SPHE.CT.AppServices/
COPY SPHE.CT.BO.Customer/. ./SPHE.CT.BO.Customer/
COPY SPHE.CT.BO.Admin/. ./SPHE.CT.BO.Admin/
COPY SPHE.CT.BO.DigitalPromoPlanner/. ./SPHE.CT.BO.DigitalPromoPlanner/
COPY SPHE.CT.BO.NewRelease/. ./SPHE.CT.BO.NewRelease/
COPY SPHE.CT.BO.PostMartemReport/. ./SPHE.CT.BO.PostMartemReport/
COPY SPHE.CT.BO.Product/. ./SPHE.CT.BO.Product/
COPY SPHE.CT.BO.Promo/. ./SPHE.CT.BO.Promo/
COPY SPHE.CT.BO.PromoPlanner/. ./SPHE.CT.BO.PromoPlanner/
COPY SPHE.CT.BO.Report/. ./SPHE.CT.BO.Report/
COPY SPHE.CT.RestClient/. ./SPHE.CT.RestClient/
#WORKDIR /source/SPHE.CT/
WORKDIR /source/SPHE.CT
RUN dotnet publish -c release -o /app --no-restore
#RUN dotnet publish "SPHE.CT.csproj" --use-current-runtime --self-contained false --no-restore -o /app
#"/SPHE.CT/SPHE.CT.csproj"

# # Enable globalization and time zones:
# # https://github.com/dotnet/dotnet-docker/blob/main/samples/enable-globalization.md
# # final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
# Changing Default Security Level and Minimum Protocol to 1 to connect to SQL server 2012 and execute EF queries as written in the code
# without this Db Operation call gets stuck from the deployed application
RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf
RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /usr/lib/ssl/openssl.cnf
RUN sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1/g' /etc/ssl/openssl.cnf
RUN sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1/g' /usr/lib/ssl/openssl.cnf


WORKDIR /app
COPY --from=build /app .
#ENTRYPOINT ["./SPHE.CT"]
ENTRYPOINT ["dotnet", "SPHE.CT.dll"]
