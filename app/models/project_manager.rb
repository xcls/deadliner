class ProjectManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def projects
    client.repos.map { |repo| Project.new(repo) }
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: user.github_token)
  end

  class Project
    include Charlatan.new(:original)
  end
end
