param apiName string
param ApiServiceName string 

resource ApiService 'Microsoft.ApiManagement/service@2021-08-01' existing =  {
  name: ApiServiceName
}

resource ApiManagementApi 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  name: apiName
  parent: ApiService
}
