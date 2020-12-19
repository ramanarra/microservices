import { Injectable } from '@nestjs/common';
import { Transport } from '@nestjs/microservices';

@Injectable()
export class ConfigService {

    private readonly envConfig: { [key: string]: any } = null;

    constructor() {
      this.envConfig = {};
      this.envConfig.redisService = {
          options: {
              url: 'redis://virujhliveredis-001.ysl6gq.0001.aps1.cache.amazonaws.com:6379',
            },
        transport: Transport.REDIS
      };
    }
  
    get(key: string): any {
      return this.envConfig[key];
    }

}
