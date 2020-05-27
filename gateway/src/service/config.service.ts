import { Injectable } from '@nestjs/common';
import { Transport } from '@nestjs/microservices';

@Injectable()
export class ConfigService {

    private readonly envConfig: { [key: string]: any } = null;

    constructor() {
      this.envConfig = {};
      this.envConfig.redisService = {
          options: {
              url: 'redis://localhost:6379',
            },
        transport: Transport.REDIS
      };
    }
  
    get(key: string): any {
      return this.envConfig[key];
    }


  //   get swaggerConfig(): ISwaggerConfigInterface {
  //     return {
  //         path: this.get('SWAGGER_PATH') || '/api/docs',
  //         title: this.get('SWAGGER_TITLE') || 'B2H Microservice API',
  //         description: this.get('SWAGGER_DESCRIPTION'),
  //         version: this.get('SWAGGER_VERSION') || '0.0.1',
  //         scheme: this.get('SWAGGER_SCHEME') === 'https' ? 'https' : 'http',
  //     };
  // }

}
