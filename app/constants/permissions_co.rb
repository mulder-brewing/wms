module PermissionsCO

  COMPANY_TYPES = Company.company_types
  ADMIN = COMPANY_TYPES[:admin]
  WAREHOUSE = COMPANY_TYPES[:warehouse]
  SHIPPER = COMPANY_TYPES[:shipper]

  PERMISSIONS = {
    dock_queue: [WAREHOUSE],
    dock_groups: [WAREHOUSE],
    docks: [WAREHOUSE],
    order_order_groups: [WAREHOUSE],
    shipper_profiles: [WAREHOUSE]
  }

  def self.check_permission_against_company_type(permission, type)
    types = PERMISSIONS[permission]
    return false unless types.respond_to?(:include?)
    return types.include?(type)
  end
end
