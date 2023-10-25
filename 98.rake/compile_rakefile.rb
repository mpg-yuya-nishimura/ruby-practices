# frozen_string_literal: true

task :compile_c do
  c_filename = 'hello'

  if system("gcc -o #{c_filename} #{c_filename}.c")
    puts 'Compilation successful. Running...'
  else
    puts 'Compilation failed.'
  end
end
