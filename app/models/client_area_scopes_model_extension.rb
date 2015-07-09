module ClientAreaScopesModelExtension
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def project_roots(project = nil)
      return ClientArea.none unless project
      ClientArea.roots.where(project: project).order(:name)
    end
  end
end