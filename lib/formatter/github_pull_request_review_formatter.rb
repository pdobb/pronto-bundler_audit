module Pronto
  module Formatter
    # Pronto::Formatter::GithubPullRequestReviewFormatter comes from the
    # Pronto gem itself.
    #
    # # Note: Ignore `method redefined` warnings on these methods.
    #
    # The methods below are feature overrides to:
    #   1. prevent the {#line_number} class from failing if none of the patches
    #      contain the `message.line.new_lineno` value found. Which can happen
    #      in the context of this pronto-bundler audit gem since we aren't
    #      necessarily altering the Gemfile.lock file within a PR at the time of
    #      finding an issue in the Gemfile.lock file.
    #   2. FIXME: Prevent a POST error due to an unknown file path in the
    #      traditional Pull Request Review comment style.
    class GithubPullRequestReviewFormatter
      def submit_comments(client, comments)
        client.publish_pull_request_comments(comments)
      rescue Octokit::UnprocessableEntity, HTTParty::Error => e
        # If Gemfile.lock doesn't exist in the PR, then attempt a non-review
        # style comment instead (which doesn't attempt to reference a file
        # path and line number).
        begin
          comments.each { |comment| client.create_pull_comment(comment) }
        rescue Octokit::UnprocessableEntity, HTTParty::Error => e
          $stderr.puts "Failed to post: #{e.message}"
        end
      end

      def line_number(message, patches)
        line = patches.find_line(message.full_path, message.line.new_lineno)
        line&.position || message.line.new_lineno
      end
    end
  end
end
