# Protect flipper endpoint so that it is only accessible by admins
# https://github.com/jnunemaker/flipper/blob/master/docs/ui/README.md
class CanAccessFlipperUI
    def self.matches?(request)
      current_user = request.env['warden'].user
      current_user.present? && current_user.respond_to?(:has_role?) && current_user.has_role?(:admin) 
    end
end