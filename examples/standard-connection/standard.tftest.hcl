run "standard" {

  assert {
    condition = can(output.requester_peering_connection_id)
    error_message = "Requester peering connection ID is not set"
  }
}