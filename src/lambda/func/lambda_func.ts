// Simple types without external dependencies
interface LambdaEvent {
  [key: string]: any;
}

interface LambdaContext {
  functionName: string;
  functionVersion: string;
  [key: string]: any;
}

interface LambdaResult {
  statusCode: number;
  body: string;
  headers?: { [key: string]: string };
}

export const handler = async (
  event: LambdaEvent,
  context: LambdaContext
): Promise<LambdaResult> => {
  console.log("Received event:", JSON.stringify(event, null, 2));
  console.log("Context:", JSON.stringify(context, null, 2));
  
  return {
    statusCode: 200,
    body: JSON.stringify({ 
      message: "Hello from TypeScript Lambda!",
      event: event,
      timestamp: new Date().toISOString()
    }),
    headers: {
      'Content-Type': 'application/json'
    }
  };
};