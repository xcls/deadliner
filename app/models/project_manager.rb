class ProjectManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def projects
    client.repos.map { |repo| Project.new(repo) }
  end

  def find_project(id)
    client.repo(id)
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: user.github_token)
  end

  class Project
    include Charlatan.new(:original)

    def id
      original.full_name
    end

    def task_count
      original.open_issues_count
    end
  end
end
