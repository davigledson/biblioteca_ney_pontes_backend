require File.join(Gem.loaded_specs["devise"].gem_dir, "app/mailers/devise/mailer")

Rails.application.config.to_prepare do
  Devise::Mailer.helper(:application)
end

module DeviseMailerSubjectOverride
  private

  def subject_for(key)
    return "Biblioteca Ney Pontes - Alteracão de senha" if key == :reset_password_instructions

    super
  end
end

Devise::Mailer.prepend(DeviseMailerSubjectOverride)