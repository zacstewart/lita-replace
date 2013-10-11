require "lita"

module Lita
  module Handlers
    class Replace < Handler
      class Buffer
        MAX_BUFFER_LENGTH = 16

        def log(message)
          messages << message
          truncate
        end

        def messages
          @messages ||= []
        end

        private

        def truncate
          if @messages.size > MAX_BUFFER_LENGTH
            @messages = messages[-MAX_BUFFER_LENGTH..-1]
          end
        end
      end

      class BufferRepository
        def self.buffers
          @buffers ||= {}
        end

        def self.buffer_for_room(room)
          buffers[room] ||= Buffer.new
        end
      end

      class Replacement
        def initialize(buffer, command)
          @buffer = buffer
          @command = command
          _, find, @replacement, @flags = command.split('/')
          @pattern = Regexp.new(find, @flags)
        end

        def replace
          message = last_matching_message.dup
          if global?
            message.body.gsub!(@pattern, @replacement)
          else
            message.body.sub!(@pattern, @replacement)
          end

          "#{message.user.name}: #{message.body}"
        end

        private

        def last_matching_message
          @buffer.messages.reverse.detect do |message|
            @pattern === message.body && message.body != @command
          end
        end

        def global?
          @flags.include?('g')
        end
      end

      route %r{(.+)}, :log
      route %r{\As\/([^\/]+)\/([^\/]+)(?:\/([ig]{1,2})?)?\Z}, :replace

      def log(response)
        buffer = get_buffer(response)
        buffer.log(response.message)
      end

      def replace(response)
        buffer = get_buffer(response)
        command = response.message.body
        replacement = Replacement.new(buffer, command)
        response.reply replacement.replace
      end

      private

      def get_buffer(response)
        room = response.message.source.room
        BufferRepository.buffer_for_room(room)
      end
    end

    Lita.register_handler(Replace)
  end
end
