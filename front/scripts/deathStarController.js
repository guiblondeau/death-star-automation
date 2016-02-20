deathStarApp.controller('deathStarController', [ '$scope', '$http', function ($scope, $http) {
  'use strict'

  function getVersion() {
    $http.get('../api/version').then(function (response) {
      $scope.version = response.data.version;
    });
  }

  getVersion();

} ])
