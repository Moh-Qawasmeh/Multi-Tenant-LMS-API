class CurrentSchoolMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    subdomain = request.subdomain
    
    # Ignore 'www' or empty subdomains if needed, or handle no subdomain
    # For now, we assume simple mapping: subdomain -> school
    

    # If running on localhost with no subdomain, treat it as 'localhost' subdomain scope
    # ALLOW OVERRIDE VIA HEADER FOR TESTING
    if request.headers['X-Subdomain'].present?
      subdomain = request.headers['X-Subdomain']
    elsif request.host.end_with?('.localhost')
      subdomain = request.host.split('.').first
    elsif subdomain.blank? && request.host == 'localhost'
      subdomain = 'localhost'
    end

    school = School.find_by(subdomain: subdomain, active: true)

    if school
      Current.school = school
      @app.call(env)
    else
      # If school not found or inactive, returning 404 or ignoring scoping (handling global or redirect)
      # For a strict multi-tenant app, maybe 404.
      # But let's verify if request is for accessing the app or maybe a landing page?
      # For simplicity, if no school found, we might not set Current.school and let the app handle it (or create a problem).
      # Requirement: "Set current school... All queries must be scoped to current_school"
      # If no school, we should probably error out or redirect.
      
      # Let's return 404 for now if subdomain is present but invalid.
      if subdomain.present? && subdomain != "www"
         [404, {'Content-Type' => 'text/html'}, ['School not found']]
      else
        @app.call(env)
      end
    end
  end
end
