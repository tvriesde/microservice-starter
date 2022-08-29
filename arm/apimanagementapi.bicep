param apiName string
param ApiService object
resource ApiManagementApi 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  name: apiName
  parent: ApiService
}
