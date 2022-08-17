module Admins
  module ConfirmaitonsHelper
    def confirmed_email?(resource)
      if resource.pending_reconfirmation?
        resource.unconfirmed_email
      else
        resource.email
      end
    end
  end
end
