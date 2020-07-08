from model.ProjectSettings import *
import logging
import os
import json
from jsonschema import validate

class ConfigurationValidator:
    @staticmethod
    def validateAgainstSchema(inputData):
        schemaFileHandle = open(os.path.join(os.path.dirname(__file__), 'configuration.schema'), 'r', encoding='utf-8')
        schema = json.loads(schemaFileHandle.read())
        validate(inputData, schema)
        ConfigurationValidator.validateModulationParams(inputData)

    @staticmethod
    def validateModulationParams(jsonData):
        modulation = jsonData.get(Modulation.description())
        if modulation == None:
            return
        params = modulation[Modulation.Properties.Params.value]
        if modulation[Modulation.Properties.Function.value] == ModulationFunctions.TANH.value:
            paramsSchemaFileHandle = open(os.path.join(os.path.dirname(__file__), 'TanhParameters.schema'), 'r', encoding='utf-8')
            schema = json.loads(paramsSchemaFileHandle.read())
            validate(params, schema)
