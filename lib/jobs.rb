require "jobs/version"

module Jobs
  def self.order(job_struct)

    # Make sure we've been provided with the correct parameter type
    raise ArgumentError, '' unless job_struct.is_a? Hash or String

    # If we've not been provided with jobs to run, then return an empty sequence
    return '' if job_struct.is_a? String and job_struct.empty?

  end
end
