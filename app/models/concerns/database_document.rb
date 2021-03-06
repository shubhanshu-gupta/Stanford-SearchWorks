# We may want to abstract this out into a more
# generic ResourceType or DocumentType class that
# can identify all the different types appropriately.
module DatabaseDocument
  def is_a_database?
    self.has_key?(self.format_key) and self[self.format_key].include? "Database"
  end
end
