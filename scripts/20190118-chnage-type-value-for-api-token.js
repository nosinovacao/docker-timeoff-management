"use strict";

const models = require("../lib/model/db");

module.exports = {
  up: function (queryInterface, Sequelize) {
    return queryInterface.describeTable("Companies").then((attributes) => {
      if (attributes.integration_api_token.type === "UUID") {
        return 1;
      }

      return queryInterface.changeColumn(
        "Companies",
        "integration_api_token",
        models.Company.attributes.integration_api_token
      );
    });
  },

  down: function (queryInterface, Sequelize) {
    // No way back!
    return Promise.resolve();
  },
};
