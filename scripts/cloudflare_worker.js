/**
 * Cloudflare Worker Proxy for Groq API
 * 
 * Purpose: 
 * 1. Bypass Geo-blocking (Syria) by routing requests through Cloudflare Edge.
 * 2. Hide API Key (Injects key on server-side).
 * 3. Handle CORS.
 * 
 * Setup:
 * 1. Deploy to Cloudflare Workers.
 * 2. Set 'GROQ_API_KEY' in Worker Settings > Variables.
 */

export default {
  async fetch(request, env) {
    // Handle CORS Preflight
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization",
        },
      });
    }

    // Only allow POST
    if (request.method !== "POST") {
      return new Response("Method Not Allowed", { status: 405 });
    }

    const groqUrl = "https://api.groq.com/openai/v1/chat/completions";
    
    // Parse request body
    let body;
    try {
      body = await request.json();
    } catch (e) {
      return new Response("Bad Request: Invalid JSON", { status: 400 });
    }

    // Create new request to Groq with injected API Key
    const newRequest = new Request(groqUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${env.GROQ_API_KEY}`, // Secret key from Env
      },
      body: JSON.stringify(body),
    });

    try {
      const response = await fetch(newRequest);
      const data = await response.json();
      
      // Return response to Flutter App with CORS headers
      return new Response(JSON.stringify(data), {
        status: response.status,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*", 
        },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: "Proxy Error: " + err.message }), {
        status: 500,
        headers: {
           "Content-Type": "application/json",
           "Access-Control-Allow-Origin": "*",
        }
      });
    }
  },
};
