
import os
import pandas as pd
import torch
import torch.nn as nn
import transformers
from transformers import AutoTokenizer, AutoModelForCausalLM, LlamaForCausalLM
import torch
import pandas as pd 
import os
import subprocess

def subtract_prompt(row):
    return row['Generation'][len(row['Prompt']):]

def remove_prompt_from_output(prompt, output):
    # Ensure the output starts with the prompt
    if output.startswith(prompt):
        print("Trimmed output: ", output[len(prompt):])
        return output[len(prompt):]
    else:
        print("Error: The output does not start with the prompt.")
        print("Output: ", output)
        return output

def list_directories(path):
    print("Listing directories: ")
    return [d for d in os.listdir(path) if os.path.isdir(os.path.join(path, d))]



def write_results(prompt, result_text, iteration, sample, module_name):
    print("Writing result file: ")
    filepath = "flexibility_llama13b_dump2/tmp7/" + iteration +"_" + sample + "_" + module_name + ".v"
    with open(filepath, 'w') as temp_file:
        full_text = result_text
        temp_file.write(full_text)
    return filepath

def read_prompt(prompt_file):
        print("Reading prompt")
        output_prompt = ""
        if prompt_file.endswith(".v"):
                with open(prompt_file, 'r') as file:
                    output_prompt = file.read()
        else:
            print(prompt_file)
            print("Error reading the prompt")
            return 0
        return output_prompt


def compile_code(output_file, result_file, testbench_path):
        proc = subprocess.run(["iverilog", "-o", output_file, "-g2012", result_file, testbench_path],capture_output=True,text=True)
        if proc.returncode != 0:
            print("error compiling testbench: ", testbench_path)
            print("Return code:", proc.returncode)
            print("stderr:", proc.stderr)
        elif proc.stderr != "":
            print("Warnings compiling testbench: ", testbench_path)
            print("stderr:", proc.stderr)
        else:
            print("Successful compilation - running simulation")
        return proc

def codellama_generate(prompt):

    print("Attempting new generate: ")
    input_ids = tokenizer(prompt, return_tensors='pt').to("cuda")
    with torch.cuda.amp.autocast():
        output_sequence = model.generate(
            **input_ids,
            max_new_tokens=1024,
            temperature = 0.7,
            top_k=10,
            top_p=0.95,
            #do_sample=False,
            do_sample=True,
        )
    #output_sequence = output_sequence[0].tolist()

    text = tokenizer.decode(output_sequence[0], skip_special_tokens=True)
    top_module_index = text.find("module top_module (")
    end_token_index = text.find("endmodule", top_module_index)
    if end_token_index != -1:
        print("Cutting off at first endmodule: ")
        text = text[:end_token_index] + "endmodule"
    print("Generated text: ")
    print(text)

    return text

def simulate_code(output_file):
        try:
            simulation_output = subprocess.check_output(['vvp', output_file], stderr=subprocess.STDOUT)
            simulation_exit_code = 0
        except subprocess.CalledProcessError as e:
            simulation_output = e.output
            simulation_exit_code = e.returncode
        if simulation_exit_code == 0:
            print("Verilog testbench simulation ran successfully.")
            if b"all tests passed" in simulation_output or b"All tests passed" in simulation_output:
                print("Simulation output: ", simulation_output, end='\n\n')
                print("All testbench tests passed!")
                reward = 1
            else:
                print("Some testbench tests failed.")
                print("Simulation output: ", simulation_output,end='\n\n')
                reward = -1
        else: 
            print("Verilog testbench simulation failed.")
            print("Simulation output: ", simulation_output,end='\n\n')
            reward = -1
        return reward

#os.environ['CUDA_VISIBLE_DEVICES'] = '1'
model_name = "codellama/CodeLlama-13b-hf"
model = LlamaForCausalLM.from_pretrained(model_name, device_map="auto")

tokenizer = AutoTokenizer.from_pretrained(model_name)

#
tb_dir = "/mnt/shared-scratch/Rajendran_J/matthewdelorenzo/rltf/AutoChip/pairs"
module_dir = "/mnt/shared-scratch/Rajendran_J/matthewdelorenzo/codellama/AutoChip-main/flexibility_prompts"
#module_dir = "/mnt/shared-scratch/Rajendran_J/matthewdelorenzo/codellama/test"
pair_dirs = os.listdir(module_dir)
answers = []
scores = []
print("MODEL NAME: ", model_name)
for iteration, dir in enumerate(pair_dirs):
    dir = str(dir)
    print("-----ITERATION: ", iteration, "-------", " Module:",dir)
    sample_answers = []
    sample_scores = []	
    for sample in range(10):
        print("-------SAMPLE: ", sample, "------")
        prompt_file= os.path.join(module_dir, dir)
        reward = 1
        prompt_text = read_prompt(prompt_file)
        module_name = os.path.splitext(dir)[0]
        generation = codellama_generate(prompt_text)
        result_file = write_results(prompt_text, generation, str(iteration), str(sample), module_name)
        testbench_path = tb_dir + "/" + module_name + "/" + module_name + "_0_tb.v"
        if os.path.exists(testbench_path):
            output_file = "flexibility_llama13b_dump/tmp7/" + module_name + "_compile" + str(sample)
            proc = compile_code(output_file, result_file, testbench_path)
            if proc.returncode == 0:
                curr_reward = simulate_code(output_file)
                if(curr_reward == -1):
                    reward = -0.5
            else:
                reward = -1

            generation_trim = remove_prompt_from_output(prompt_text, generation)
        else:
            print("Error: No testbench file exists.")
            reward = -2
        sample_answers.append(generation_trim)
        sample_scores.append(reward)
    print("Reward = ", reward)
    answers.append(sample_answers)
    scores.append(sample_scores)
        
print("ALL REWARDS: ", scores)
print("ALL ANSWERS: ", answers)
