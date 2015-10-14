module CommonModelFunctions
  # Converts email addres to all-lowercase
  def downcase_email
    self.email = email.downcase
  end

  # Removes unnecessary characters from phone number
  def convert_phone_number
    self.phone = phone.tr('\ \-', "")
  end
end