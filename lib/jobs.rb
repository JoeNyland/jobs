require "jobs/version"

module Jobs

  def self.order(job_struct)

    @sequence = []

    # Make sure we've been provided with the correct parameter type
    raise ArgumentError, '' unless job_struct.is_a? Hash or String

    # If we've not been provided with jobs to run, then return an empty sequence
    return '' if job_struct.is_a? String and job_struct.empty?

    @job_struct = job_struct

    @job_struct.each do |job,dependent_job|

      # Check the job structure
      raise ArgumentError, 'jobs must be symbols' unless job.is_a? Symbol
      raise ArgumentError, 'dependent job must be a symbol or nil' unless job.is_a? Symbol or job.is_a? NilClass

      # Check if this job has already been processed (as a dependency of another job)
      next if @sequence.include? job

      unless dependent_job.nil?
        unless @sequence.include? dependent_job
          # This job has at least one dependency so we need to ensure it's dependent job(s) is/are executed first
          dependencies = process_dependency(dependent_job)
          @sequence.concat dependencies
        end
      end

      # Add the job to the job sequence
      @sequence.push job

    end

    # Return the job sequence as a string
    @sequence.join

  end

  private

  def self.process_dependency(dependent_job)
    if @job_struct[dependent_job].nil?
      # No dependencies of it's own, so it can be run on it's own
      [dependent_job]
    else
      # Dependent job has dependencies of it's own so we need to process them first
      unless @job_struct[@job_struct[dependent_job]].nil?
        process_dependency(@job_struct[dependent_job])
      end
      [@job_struct[dependent_job],dependent_job]
    end
  end

end
