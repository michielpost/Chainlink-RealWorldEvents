using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApp
{
    public class ColorHub : Hub
    {
        public async Task SendMessage(string color)
        {
            await Clients.All.SendAsync("ReceiveMessage", color);
        }
    }
}
