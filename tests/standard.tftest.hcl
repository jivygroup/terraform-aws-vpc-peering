variables {
  name = "Test"
}

run "test" {

  assert {
    condition     = length(regexall("testing", "testing")) > 0
    error_message = "Template test failed"
  }

}
