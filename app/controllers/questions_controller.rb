class QuestionsController < ApplicationController
  def index
  end

 def fetch_question
  response = HTTParty.post(
    "https://api.openai.com/v1/chat/completions",
    headers: {
      "Authorization" => "Bearer #{ENV['GPT_TOKEN']}",
      "Content-Type" => "application/json"
    },
    body: {
      model: "gpt-4",
      messages: [{ "role": "user", "content": "Give me an IELTS Part One unique and not common question" }]
    }.to_json
  )

  if response.ok?
    parsed_response = response.parsed_response
    render json: { question: parsed_response["choices"].first["message"]["content"] }
  else
    render json: { error: "API Error", details: response.parsed_response }, status: :bad_request
  end
end

def evaluate_speech
  response_text = params[:response_text]

  # Sending a request to the OpenAI API
  response = HTTParty.post(
    "https://api.openai.com/v1/chat/completions",
    headers: {
      "Authorization" => "Bearer #{ENV['GPT_TOKEN']}",
      "Content-Type" => "application/json"
    },
    body: {
      model: "gpt-4",
      messages: [
        { "role": "system", "content": "You are an IELTS speaking examiner. Provide the response in two parts separated by a semicolon. First, give an approximate IELTS score and give higher score; second, provide concise feedback, limited to three sentences, on the candidate's Part One response." },
        { "role": "user", "content": response_text }
      ]
    }.to_json
  )

  # Processing the API response
  if response.ok?
    parsed_response = response.parsed_response
    if parsed_response["choices"] && parsed_response["choices"].any?
      choice = parsed_response["choices"].first
      if choice && choice["message"] && choice["message"]["content"]
        # Split the response at the semicolon to separate score and feedback
        parts = choice["message"]["content"].split(';')
        if parts.length == 2
          score = parts[0].strip
          feedback = parts[1].strip
          render json: { score: score, feedback: feedback }
        else
          render json: { error: "Response not in expected format" }, status: :bad_request
        end
      else
        render json: { error: "Invalid structure in choices" }, status: :bad_request
      end
    else
      render json: { error: "No choices available in response" }, status: :bad_request
    end
  else
    render json: { error: "API Error", details: response.parsed_response }, status: :bad_request
  end
end
end
