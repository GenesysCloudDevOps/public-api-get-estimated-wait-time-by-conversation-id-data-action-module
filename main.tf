resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "The estimated wait time for a specific media type and queue.",
        "properties" = {
            "Conversation_ID" = {
                "description" = "Conversation id of the Interaction in queue.",
                "type" = "string"
            },
            "QUEUE_ID" = {
                "description" = "The queue ID.",
                "type" = "string"
            }
        },
        "required" = [
            "QUEUE_ID"
        ],
        "title" = "Estimated Wait Time Request",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "Returns the estimated wait time.",
        "properties" = {
            "estimated_wait_time" = {
                "description" = "The estimated wait time (in seconds) for the specified media type and queue. ",
                "type" = "integer"
            }
        },
        "title" = "Get Estimated Wait Time Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/routing/queues/$${input.QUEUE_ID}/estimatedwaittime?conversationId=$${input.Conversation_ID}"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\n   \"estimated_wait_time\": $${estimated_wait_time}\n}"
        translation_map = { 
			estimated_wait_time = "$.results[0].estimatedWaitTimeSeconds"
		}
        translation_map_defaults = {       
			estimated_wait_time = "0"
		}
    }
}